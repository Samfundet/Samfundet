require 'csv'

namespace :db do
  desc "Export all database tables to CSV"
  task export_to_csv: :environment do
    export_dir = Rails.root.join('db', 'csv_exports')
    FileUtils.mkdir_p(export_dir)

    Rails.application.eager_load!

    ActiveRecord::Base.descendants.each do |model|
      next if model.abstract_class? || !model.table_exists?

      file_path = export_dir.join("#{model.name.underscore.pluralize}.csv")
      FileUtils.mkdir_p(File.dirname(file_path))

      puts "Exporting #{model.name} to #{file_path}..."

      begin
        CSV.open(file_path, "w") do |csv|
          columns = model.column_names
          csv << columns

          if model.primary_key.present?
            # Use find_each with batching if we can paginate by PK
            model.find_each(batch_size: 1000) do |record|
              csv << columns.map { |col| record.public_send(col) }
            end
          else
            # Fall back to a plain .all.each if no PK
            model.all.each do |record|
              csv << columns.map { |col| record.public_send(col) }
            end
          end
        end
      rescue => e
        puts "❌ Failed to export #{model.name}: #{e.message}"
      end
    end

    puts "✅ Done exporting CSVs to #{export_dir}"
  end
end