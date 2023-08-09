# frozen_string_literal: true

# lib/tasks/db.rake
namespace :db do
  desc 'Dumps the database to db/APP_NAME.dump'
  task dump: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task restore: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    puts cmd
    exec cmd
  end

  task dump_mdb2: :environment do
    cmd = nil
    with_config do |app, host|
      cmd = "pg_dump --host #{host} --username limweb --verbose --clean --no-owner --no-acl --format=c mdb2 > #{Rails.root}/db/#{app}mdb2.dump"
    end
    puts cmd
    exec cmd
  end

  task restore_mdb2: :environment do
    cmd = nil

    with_config do |app, host|
      cmd = "pg_restore --verbose --host #{host} --username limweb --clean --no-owner --no-acl --dbname mdb2 #{Rails.root}/db/#{app}mdb2.dump"
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    puts cmd
    exec cmd
  end

private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
