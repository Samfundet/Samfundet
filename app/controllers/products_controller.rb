# frozen_string_literal: true

class ProductsController < ApplicationController
  load_and_authorize_resource
  def index
    @products = Product.includes(:product_variations)
  end

  def admin
    @products = Product.includes(:product_variations)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
  end

private

  def product_params
    params.require(:product).permit(
      :name,
      :price
    )
  end
end
