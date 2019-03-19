# frozen_string_literal: true

class BlogsController < ApplicationController
  authorize_resource
  has_control_panel_applet :admin_applet,
                           if: -> { can? :edit, Blog }

  def index
    @articles = Blog.published.order('publish_at desc')
  end

  def show
    @article = Blog.find(params[:id])
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
