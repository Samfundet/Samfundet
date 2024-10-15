# frozen_string_literal: true

class Sulten::MenuItemsController < Sulten::BaseController
  load_and_authorize_resource

  def new
    @menu_item = Sulten::MenuItem.new
    render 'sulten/menu/new_item'
  end

  def create
    @menu_item = Sulten::MenuItem.new(menu_item_params)
    if @menu_item.save
      flash[:success] = t('helpers.models.sulten.menu.item.success.create')
      redirect_to sulten_admin_menu_index_path
    else
      flash.now[:error] = t('helpers.models.sulten.menu.item.error.create')
      render 'sulten/menu/new_item'
    end
  end

  def edit
    @menu_item = Sulten::MenuItem.find(params[:id])
    render 'sulten/menu/edit_item'
  end

  def update
    @menu_item = Sulten::MenuItem.find(params[:id])
    if @menu_item.update(menu_item_params)
      flash[:success] = t('helpers.models.sulten.menu.item.success.update')
      redirect_to sulten_admin_menu_index_path
    else
      flash.now[:error] = t('helpers.models.sulten.menu.item.error.update')
      render 'sulten/menu/edit_item'
    end
  end

  def destroy
    @menu_item = Sulten::MenuItem.find(params[:id])
    if @menu_item.destroy
      flash[:success] = t('helpers.models.sulten.menu.item.success.destroy')
    else
      flash[:error] = t('helpers.models.sulten.menu.item.error.destroy')
    end
    redirect_to sulten_admin_menu_index_path
  end

  private

  def menu_item_params
    params.require(:sulten_menu_item)
          .permit(:title_no,
                  :title_en,
                  :description_no,
                  :description_en,
                  :additional_info_no,
                  :additional_info_en,
                  :allergies_no,
                  :allergies_en,
                  :recommendation,
                  :price,
                  :price_member,
                  :category_id,
                  :order)
  end
end