raise "Not allowed to seed a production database!" if Rails.env.production?
if Rails.env.development?
  tables = ActiveRecord::Base.connection.tables
  tables.delete("schema_migrations")
  puts "Truncating tables #{tables * ", "}."
  
  tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE")
  end
  
  # Invoke gem seedscripts
  Rake::Task['samfundet_auth_engine:db:seed'].invoke
  #Authorization.ignore_access_control(true)
  Rake::Task['samfundet_domain_engine:db:seed'].invoke
end