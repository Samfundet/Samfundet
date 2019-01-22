# frozen_string_literal: true

module Queries
  class QueryType < Types::Bases::BaseObject
    field :get_events, Types::EventType.connection_type, null: false do
      description 'Get events.'
    end

    def get_events
      Event.all
    end

    field :get_blog_posts, Types::BlogPostType.connection_type, null: false do
      description 'Get blog posts'
    end

    def get_blog_posts
      Blog.published
    end

    field :get_blog_post, Types::BlogPostType, null: true do
      argument :id, ID, required: true
      description 'Get a blog post'
    end

    def get_blog_post(id:)
      Blog.find(id)
    end

    field :get_event, Types::EventType, null: true do
      argument :id, ID, required: true
      description 'Get a single event.'
    end

    def get_event(id:)
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
