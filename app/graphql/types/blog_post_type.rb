# frozen_string_literal: true

module Types
  class BlogPostType < Bases::BaseObject
    field :author, MemberType, null: false

    field :title, String, null: false do
      argument :language, Language, required: false
    end
    def title(language: 'NO')
      object.public_send("title_#{language.downcase}")
    end

    field :content, String, null: false do
      argument :language, Language, required: false
    end
    def content(language: 'NO')
      object.public_send("content_#{language.downcase}")
    end

    field :lead_paragraph, String, null: false do
      argument :language, Language, required: false
    end
    def lead_paragraph(language: 'NO')
      object.public_send("lead_paragraph_#{language.downcase}")
    end
  end
end
