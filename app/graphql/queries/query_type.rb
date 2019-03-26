# frozen_string_literal: true

module Queries
  class QueryType < GraphQL::Schema::Object
    field :events, Types::Event.connection_type, null: false do
      description 'Get events.'
    end
    def events
      Event.all.includes(:area, :billig_event, :price_groups)
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

    field :event, Types::Event, null: true do
      argument :id, ID, required: true
      description 'Get a single event.'
    end
    def event(id:)
      Event.find_by(id: id)
    end

    field :groups, Types::GroupType.connection_type, null: false do
      description 'Get all groups.'
    end
    def groups
      Group.all
    end

    field :group, Types::GroupType, null: false do
      argument :id, ID, required: true
      description 'Get a single group.'
    end
    def group(id:)
      Group.find(id)
    end

    field :members, Types::MemberType.connection_type, null: false do
      description 'Get all members.'
    end
    def members
      Member.all
    end

    field :member, Types::MemberType, null: false do
      argument :id, ID, required: true
      description 'Get a single member.'
    end
    def member(id:)
      Member.find(id)
    end

    field :jobs, Types::JobType.connection_type, null: false do
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

    field :page, Types::PageType, null: true do
      description 'Get a single page.'
    end
    def page(id:)
      argument :id, ID, required: true
      Page.find(id).includes(:revisions)
    end

    field :document, Types::Document, null: false do
      description 'Get a single document.'
    end

    def document(id:)
      argument :id, ID, required: true
      Document.find id
    end

    field :documents, Types::Document.connection_type, null: false do
      description 'Get all documents.'
    end

    def documents
      Document.all
    end
  end
end
