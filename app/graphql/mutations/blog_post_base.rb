# frozen_string_literal: true

class Mutations::BlogPostBase < GraphQL::Schema::Mutation
  argument :title_no, String, required: true
  argument :title_en, String, required: true

  argument :content_no, String, required: true
  argument :content_en, String, required: true

  argument :lead_paragraph_no, String, required: true
  argument :lead_paragraph_en, String, required: true

  argument :author_id, Integer, required: true

  argument :published, Boolean, required: true
  argument :publish_at, GraphQL::Types::ISO8601DateTime, required: true

  argument :image_id, Integer, required: false
end
