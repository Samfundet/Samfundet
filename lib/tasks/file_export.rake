require 'fileutils'

namespace :db do
  desc "Export all uploaded files from public/upload to db/file_exports/upload"
  task export_files: :environment do
    source_root = Rails.root.join("public", "upload")
    export_root = Rails.root.join("db", "file_exports", "upload")

    unless Dir.exist?(source_root)
      puts "❌ No upload directory found at #{source_root}"
      next
    end

    FileUtils.mkdir_p(export_root)

    puts "📦 Starting export of uploaded files..."
    puts "Source: #{source_root}"
    puts "Destination: #{export_root}"
    puts "-" * 60

    begin
      # Copy recursively while preserving directory structure
      FileUtils.cp_r("#{source_root}/.", export_root, preserve: true)
      puts "✅ Successfully exported all uploaded files to #{export_root}"
    rescue => e
      puts "❌ Export failed: #{e.class} - #{e.message}"
      puts e.backtrace.first(3).join("\n")
    end
  end
end