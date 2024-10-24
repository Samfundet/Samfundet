# frozen_string_literal: true

class Sulten::MenuCategoriesController < Sulten::BaseController
  load_and_authorize_resource

  def new
    @menu_category = Sulten::MenuCategory.new
    render 'sulten/menu/new_category'
  end

  def create
    @menu_category = Sulten::MenuCategory.new(menu_category_params)
    if @menu_category.save
      flash[:success] = t('helpers.models.sulten.menu.category.success.create')
      redirect_to sulten_admin_menu_index_path
    else
      flash.now[:error] = t('helpers.models.sulten.menu.category.error.create')
      render 'sulten/menu/new_category'
    end
  end

  def edit
    @menu_category = Sulten::MenuCategory.find(params[:id])
    render 'sulten/menu/edit_category'
  end

  def update
    @menu_category = Sulten::MenuCategory.find(params[:id])
    if @menu_category.update(menu_category_params)
      flash[:success] = t('helpers.models.sulten.menu.category.success.update')
      redirect_to sulten_admin_menu_index_path
    else
      flash.now[:error] = t('helpers.models.sulten.menu.category.error.update')
      render 'sulten/menu/edit_category'
    end
  end

  def destroy
    @menu_category = Sulten::MenuCategory.find(params[:id])
    if @menu_category.destroy
      flash[:success] = t('helpers.models.sulten.menu.category.success.destroy')
    else
      flash.now[:error] = t('helpers.models.sulten.menu.category.error.destroy')
    end
    redirect_to sulten_admin_menu_index_path
  end

private

  def menu_category_params
    params.require(:sulten_menu_category).permit(:title_no, :title_en, :order)
  end
end
