# frozen_string_literal: true

class RailsPaths < GraphQL::Schema::Object
  field :base, String, "Base path of the given resource", null: false
  def base
    Rails.application.routes.url_helpers.public_send("#{object.class.name.demodulize.downcase}_path", object)
  end

  field :admin, String, "Admin path for the resource type", null: false
  def admin
    Rails.application.routes.url_helpers.public_send("admin_#{object.class.name.demodulize.downcase}s_path")
  end

  field :edit, String, "Edit path of the given resource", null: false
  def edit
    Rails.application.routes.url_helpers.public_send("edit_#{object.class.name.demodulize.downcase}_path", object)
  end

  field :new, String, "New path of the resource type", null: false
  def new
    Rails.application.routes.url_helpers.public_send("new_#{object.class.name.demodulize.downcase}_path")
  end
end

module Types
  module Bases
    class RailsResource < BaseObject
      field :paths, RailsPaths, "Paths for the resource in the Rails project", null: false
      def paths
        object
      end
    end
  end
end
