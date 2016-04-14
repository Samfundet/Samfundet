class BlogsController < ApplicationController
  filter_access_to [:admin], require: :edit

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :blogs }

  def index
    @articles = Blog.published
  end

  def show
    @article = Blog.find(params[:id])
  end

  def new
    @article = Blog.new
  end

  def create
    @article = Blog.new(params[:blog])
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

    if @article.update_attributes(params[:blog])
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

  def admin_applet
  end
end
