# -*- encoding : utf-8 -*-
class ImagesController < ApplicationController
  has_control_panel_applet :admin_applet,
    if: -> { permitted_to? :edit, :images }

  def index
    @images = Image.paginate(page: params[:page], per_page: 10)
    if request.xhr?
      render layout: false
    end
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.create(params[:image])
    if @image.save
      flash[:success] = t('images.create_success')
      redirect_to @image
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:success] = t('common.update_success')
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
    if request.xhr?
      render '_image_list', layout: false
    end
  end

  def admin_applet
  end
end
