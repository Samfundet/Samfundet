# frozen_string_literal: true

module Queries
  class QueryType < Types::Bases::BaseObject
    field :events, Types::EventType.connection_type, null: false do
      description 'Get events.'
    end

    def events
      Event.all
    end

    field :blog_posts, Types::BlogPostType.connection_type, null: false do
      description 'Get blog posts'
    end

    def blog_posts
      Blog.published
    end

    field :blog_post, Types::BlogPostType, null: true do
      argument :id, ID, required: true
      description 'Get a blog post'
    end

    def blog_post(id:)
      Blog.find(id)
    end

    field :event, Types::EventType, null: true do
      argument :id, ID, required: true
      description 'Get a single event.'
    end

    def event(id:)
      Event.find_by(id: id)
    end

    field :groups, [Types::GroupType], null: false do
      description 'Get all groups.'
    end

    def groups
      Group.all
    end

    field :jobs, [Types::JobType], null: false do
      description 'Get all jobs.'
    end

    def jobs
      Job.all
    end

    field :pages, Types::PageType.connection_type, null: false do
      description 'Get all pages.'
    end
    def pages
      Page.all.includes(:revisions)
    end
  end
end
