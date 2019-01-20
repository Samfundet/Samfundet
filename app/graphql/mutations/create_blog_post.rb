# frozen_string_literal: true

class Mutations::CreateBlogPost < Mutations::BlogPostBase
  null true

  argument :blog_post_input, Types::Inputs::BlogPostInput, required: true

  field :blog_post, Types::BlogPostType, null: true
  field :success, Boolean, null: false
  field :errors, String, null: true

  def resolve(**kwargs)
    e = Blog.new(kwargs)
    if e.save
      {
        blog_post: e,
        success: true
      }
    else
      {
        success: false,
        errors: e.errors.full_messages
      }
    end
  end
end
