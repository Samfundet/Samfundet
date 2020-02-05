# frozen_string_literal: true

class DocumentsController < ApplicationController
  # Not necessary to load resource here as we have not conditional permissions
  # and we're loading the resource manually in each action
  authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, Document }

  def admin
    @categories = DocumentCategory.includes(:documents)
  end

  def index
    @categories = DocumentCategory.includes(:documents)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.uploader_id = current_user.id
    if @document.save
      flash[:success] = t('documents.create_success')
      redirect_to admin_documents_path
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    @document.uploader_id = current_user.id
    if @document.update_attributes(document_params)
      flash[:success] = t('documents.edit_success')
      redirect_to admin_documents_path
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:success] = t('documents.destroy_success')
    redirect_to admin_documents_path
  end

  def admin_applet; end

private

  def document_params
    params.require(:document).permit(:uploader_id, :title, :category, :category_id, :file, :publication_date)
  end
end
