# frozen_string_literal: true

module Mutations
  class MutationType < GraphQL::Schema::Object
    field :authenticate, mutation: Mutations::Authenticate
    field :update_event, mutation: Mutations::UpdateEvent
    field :create_blog_post, mutation: Mutations::CreateBlogPost
    field :update_blog_post, mutation: Mutations::UpdateBlogPost
    field :delete_blog_post, mutation: Mutations::DeleteBlogPost
  end
end
