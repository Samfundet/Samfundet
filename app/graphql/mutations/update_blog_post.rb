# frozen_string_literal: true

class Mutations::UpdateBlogPost < Mutations::BlogPostBase
  argument :id, ID, required: true, description: 'ID of a blog post.'
  argument :blog_post_input, Types::Inputs::BlogPostInput, required: true, description: 'The blog post.'

  description 'Update a blog post.'

  field :blog_post, Types::BlogPostType, null: true
  field :success, Boolean, null: false
  field :errors, Types::JsonType, null: true

  def resolve(id:, blog_post_input:)
    b = Blog.find(id)
    if b.update(blog_post_input.to_h)
      {
        blog_post: b,
        success: true
      }
    else
      {
        errors: b.errors.to_hash,
        success: false
      }
    end
  end
end
