# frozen_string_literal: true

class ProductsController < ApplicationController
  load_and_authorize_resource
  def index
    @products = Product.includes(:product_variations)
  end

  def admin
    @products = Product.includes(:product_variations)
    @product_variations = ProductVariation.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path
    else
      render :new
    end
  end


  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path
    else
      redirect_to :edit
    end
  end

  def destroy
    @supporter = Product.find(params[:id])
    @supporter.destroy
    redirect_to admin_products_path
  end

  def new_product_variation
    @product = Product.find(params[:id])
    @product_variation = @product.product_variations.build
  end


private

  def product_params
    params.require(:product).permit(
      :name_no, :name_en,
      :price,
      :has_variations,
      :amount,
      :image_id
    )
  end
end
