# frozen_string_literal: true

class Sulten::MenuController < Sulten::BaseController
  before_action :authorize

  def index
    @categories = Sulten::MenuCategory.all
    @items = Sulten::MenuItem.order(:category_id, :order, :title_no).includes(:sulten_menu_category).all
  end

private

  def authorize
    authorize! :manage, Sulten::MenuItem, Sulten::MenuCategory
  end
end
