# frozen_string_literal: true

class Mutations::DeleteBlogPost < GraphQL::Schema::Mutation
  null true
  argument :id, ID, required: true

  field :success, Boolean, null: false

  def resolve(id:)
    b = Blog.find(id)
    if b.destroy
      {
        success: true
      }
    else
      {
        success: false
      }
    end
  end
end
