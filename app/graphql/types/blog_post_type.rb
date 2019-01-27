# frozen_string_literal: true

module Types
  class BlogPostType < Bases::BaseObject
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

    field :blog_path, String, null: false
    def blog_path
      Rails.application.routes.url_helpers.blog_path(object)
    end

    field :admin_blog_path, String, null: false
    def admin_blog_path
      Rails.application.routes.url_helpers.admin_blogs_path
    end

    field :edit_blog_path, String, null: false
    def edit_blog_path
      Rails.application.routes.url_helpers.edit_blog_path(object)
    end

    field :new_blog_path, String, null: false
    def new_blog_path
      Rails.application.routes.url_helpers.new_blog_path
    end
  end
end
