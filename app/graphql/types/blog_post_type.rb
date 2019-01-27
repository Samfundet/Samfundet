# frozen_string_literal: true
#
module Types
  class RailsPaths < Bases::BaseObject
    field :path, String, null: false
    def path
      Rails.application.routes.url_helpers.public_send("#{object.class.name.demodulize.downcase}_path", object)
    end

    field :admin_path, String, null: false
    def admin_path
      Rails.application.routes.url_helpers.public_send("admin_#{object.class.name.demodulize.downcase}s_path")
    end

    field :edit_path, String, null: false
    def edit_path
      Rails.application.routes.url_helpers.public_send("edit_#{object.class.name.demodulize.downcase}_path", object)
    end

    field :new_path, String, null: false
    def new_path
      Rails.application.routes.url_helpers.public_send("new_#{object.class.name.demodulize.downcase}_path")
    end
  end

  class BlogPostType < RailsPaths
    field :author, MemberType, null: false

    field :title, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def title(language: 'NO')
      object.public_send("title_#{language.downcase}")
    end

    field :content, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def content(language: 'NO')
      object.public_send("content_#{language.downcase}")
    end

    field :lead_paragraph, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def lead_paragraph(language: 'NO')
      object.public_send("lead_paragraph_#{language.downcase}")
    end

    field :publish_at, GraphQL::Types::ISO8601DateTime, null: false
    field :published, Boolean, null: false

    field :image_id, ID, null: true

  end
end
