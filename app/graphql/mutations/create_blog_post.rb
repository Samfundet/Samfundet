# frozen_string_literal: true

class Mutations::CreateBlogPost < Mutations::BlogPostBase
  null true

  argument :blog_post_input, Types::Inputs::BlogPostInput, required: true, description: "The blog post."


  description "Create a blog post."

  field :blog_post, Types::BlogPostType, null: true
  field :success, Boolean, null: false
  field :errors, Types::JsonType, null: true

  def resolve(blog_post_input:)
    e = Blog.new(blog_post_input.to_h)
    if e.save
      {
        blog_post: e,
        success: true
      }
    else
      {
        success: false,
        errors: e.errors.to_hash
      }
    end
  end
end
