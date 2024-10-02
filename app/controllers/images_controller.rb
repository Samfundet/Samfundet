# frozen_string_literal: true

class ImagesController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :edit, Image }

  def index
    @images = Image.paginate(page: params[:page], per_page: 10)
    @tags = Tag.paginate(page: params[:tags], per_page: 40)
    render layout: false if request.xhr?
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.create(image_params)
    @image.uploader = current_user
    if @image.save
      flash[:success] = t('images.create_success')
      redirect_to @image
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @image.update(image_params)
      flash[:success] = t('images.update_success')
      redirect_to @image
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:success] = t('images.destroy_success')
    redirect_to images_path
  end

  def search
    @images = Image.text_search(params[:search])
    render '_image_list', layout: false if request.xhr?
  end

  def admin_applet; end

private

  def image_params
    params.require(:image).permit(:title, :tagstring, :image_file)
  end
end
