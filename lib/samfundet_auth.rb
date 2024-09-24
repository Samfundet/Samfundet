require 'active_support/configurable'
require 'samfundet_auth/engine'
require './app/models/member'

module SamfundetAuth
  include ActiveSupport::Configurable

  class << self
    def setup
      yield config

      database_path = "#{Rails.root}/config/database.yml"

      return unless File.exist?(database_path)

      database_config = YAML.load_file(database_path, aliases: true)

      if config.domain_database
        [Role, MembersRole].each do |model|
          model.establish_connection(database_config[config.domain_database.to_s])
        end
      end

      Member.establish_connection(database_config[config.member_database.to_s]) if config.member_database

      return unless config.member_table

      Member.table_name = config.member_table.to_s
    end
  end
end
