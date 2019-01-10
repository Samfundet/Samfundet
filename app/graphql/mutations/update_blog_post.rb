# frozen_string_literal: true

class Mutations::UpdateBlogPost < Mutations::BlogPostBase
  null true
  argument :id, ID, required: true

  field :blog_post, Types::BlogPostType, null: true
  field :success, Boolean, null: false
  field :errors, String, null: true

  def resolve(**kwargs)
    puts kwargs
    b = Blog.find(kwargs[:id])
    if b.update(kwargs)
      {
        blog_post: b,
        success: true
      }
    else
      {
        errors: b.errors.full_messages,
        success: false
      }
    end
  end
end
