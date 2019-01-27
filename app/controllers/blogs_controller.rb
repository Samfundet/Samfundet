# frozen_string_literal: true

class BlogsController < ApplicationController
  GET_ALL = GraphQL.parse <<-'GRAPHQL'
    query {
      getBlogPosts {
        edges {
          node {
            id
            title
          }
        }
      }
    }
  GRAPHQL

  GET_ONE = GraphQL.parse <<-'GRAPHQL'
    query GET_ONE($id: ID!) {
      payload: getBlogPost(id: $id) {
        id
        title
        author {
          forename
          surname
        }
        content
        publishAt
        imageId
        blogPath
        newBlogPath
        editBlogPath
        adminBlogPath
      }
    }
  GRAPHQL

  filter_access_to [:admin], require: :edit

  has_control_panel_applet :admin_applet,
    if: -> { permitted_to? :edit, :blogs }

  def index
    @articles = Blog.published.order('publish_at desc')
  end

  def show
    result = SamfundetSchema.execute(document: GET_ONE, variables: {id: params[:id]})
    @article = result.to_h["data"]["payload"]
  end

  def new
    @article = Blog.new
  end

  def create
    @article = Blog.new(blog_params)
    @article.author = current_user

    if @article.save
      flash[:success] = t('events.create_success')
      redirect_to @article
    else
      flash.now[:error] = t('events.create_error')
      render :new
    end
  end

  def edit
    @article = Blog.find(params[:id])
  end

  def destroy
    @article = Blog.find(params[:id])
    if @article.destroy
      redirect_to blogs_path
    else
      redirect_to @article
    end
  end

  def update
    @article = Blog.find(params[:id])

    if @article.update_attributes(blog_params)
      flash[:success] = t('events.update_success')
      redirect_to @article
    else
      flash.now[:success] = t('events.update_failure')
      render :edit
    end
  end

  def admin
    @articles = Blog.all
  end

  def admin_applet; end

  private

  def blog_params
    params.require(:blog).permit(:title_no, :title_en, :lead_paragraph_no, :lead_paragraph_en, :content_no, :content_en, :published, :publish_at, :image_id)
  end
end
