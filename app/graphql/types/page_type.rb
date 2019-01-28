# frozen_string_literal: true

module Types
  class PageType < Bases::RailsResource
    field :name, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def name(language:)
      object["name_#{language.downcase}"]
    end

    field :title, String, null: true do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def title(language:)
      object.public_send("title_#{language.downcase}")
    end

    field :content, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end
    def content(language:)
      object.public_send("content_#{language.downcase}")
    end

    field :author, MemberType, null: true
    def author
      object.public_send('author')
    end
  end
end
