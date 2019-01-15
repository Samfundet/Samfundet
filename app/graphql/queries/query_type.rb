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

    field :event, Types::EventType, null: true do
      argument :id, Integer, required: true
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
  end
end
