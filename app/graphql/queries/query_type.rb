# frozen_string_literal: true

module Queries
  class QueryType < GraphQL::Schema::Object
    field :get_events, Types::Event.connection_type, null: false do
      description 'Get events.'
    end
    def get_events
      Event.all.includes(:area, :billig_event, :price_groups)
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

    field :get_event, Types::Event, null: true do
      argument :id, ID, required: true
      description 'Get a single event.'
    end
    def get_event(id:)
      Event.find_by(id: id)
    end

    field :get_groups, Types::GroupType.connection_type, null: false do
      description 'Get all groups.'
    end
    def get_groups
      Group.all
    end

    field :get_group, Types::GroupType, null: false do
      argument :id, ID, required: true
      description 'Get a single group.'
    end
    def get_group(id:)
      Group.find(id)
    end

    field :get_members, Types::MemberType.connection_type, null: false do
      description 'Get all members.'
    end
    def get_members
      Member.all
    end

    field :get_member, Types::MemberType, null: false do
      argument :id, ID, required: true
      description 'Get a single member.'
    end
    def get_member(id:)
      Member.find(id)
    end

    field :jobs, [Types::JobType], null: false do
      description 'Get all jobs.'
    end
    def jobs
      Job.all
    end

    field :get_pages, Types::PageType.connection_type, null: false do
      description 'Get all pages.'
    end
    def get_pages
      Page.all.includes(:revisions)
    end

    field :get_page, Types::PageType, null: true do
      description 'Get a single page.'
    end
    def get_page(id:)
      argument :id, ID, required: true
      Page.find(id).includes(:revisions)
    end

    field :roles, Types::Role.connection_type, null: false do
      argument :root, Boolean, required: false
    end
    def roles(root:)
      if root
        Role.where(role_id: nil).includes(:roles).all
      else
        Role.includes(:role, :roles).all
      end
    end
  end
end
