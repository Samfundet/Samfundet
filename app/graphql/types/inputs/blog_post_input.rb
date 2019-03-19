# frozen_string_literal: true

module Types
  module Inputs
    class BlogPostInput < Types::Bases::BaseInputObject
      argument :title_no, String, required: true do
        description 'Norwegian title'
      end

      argument :title_en, String, required: true do
        description 'English title'
      end

<<<<<<< HEAD
      argument :content_no, String, required: true
      argument :content_en, String, required: true
=======
      argument :content_no, Types::Text, required: true
      argument :content_en, Types::Text, required: true
>>>>>>> c1b3ee52b9282d57a3d2ca3ae104593a4232592b

      argument :lead_paragraph_no, String, required: true
      argument :lead_paragraph_en, String, required: true

      # argument :author, Types::MemberType, required: true

      argument :published, Boolean, required: false, default_value: false
      argument :publish_at, GraphQL::Types::ISO8601DateTime, required: true

      argument :image_id, Integer, required: false
<<<<<<< HEAD
=======

      argument :author_id, Integer, required: true
>>>>>>> c1b3ee52b9282d57a3d2ca3ae104593a4232592b
    end
  end
end
