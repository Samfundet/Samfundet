# frozen_string_literal: true
#
class RailsPaths < GraphQL::Schema::Object
  field :base, String, null: false
  def base
    Rails.application.routes.url_helpers.public_send("#{object.class.name.demodulize.downcase}_path", object)
  end

  field :admin, String, null: false
  def admin
    Rails.application.routes.url_helpers.public_send("admin_#{object.class.name.demodulize.downcase}s_path")
  end

  field :edit, String, null: false
  def edit
    Rails.application.routes.url_helpers.public_send("edit_#{object.class.name.demodulize.downcase}_path", object)
  end

  field :new, String, null: false
  def new
    Rails.application.routes.url_helpers.public_send("new_#{object.class.name.demodulize.downcase}_path")
  end
end

module Types
  module Bases
    class RailsResource < BaseObject
      field :paths, RailsPaths, null: false
      def paths
        object
      end
    end
  end
end
