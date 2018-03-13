# frozen_string_literal: true

class DocumentsController < ApplicationController
  filter_access_to :admin, require: :manage

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :manage, :documents }

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
    @document = Document.new(document_param)
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
    @document = Document.find params[:id]
    @document.uploader_id = current_user.id
    if @document.update_attributes(params[:document])
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
    flash[:success] = t('document.destroy_success')
    redirect_to admin_documents_path
  end

  def admin_applet; end

  private

  def document_params
    params.require(:document).permit(:uploader_id, :title, :category, :category_id, :file, :publication_date)
  end

end
