# frozen_string_literal: true

class ProductVariationsController < ApplicationController
  load_and_authorize_resource

  def edit
    @product_variation = ProductVariation.find(params[:id])
    @product = @product_variation.product
    render file: 'products/edit_product_variation'
  end

  def update
    @product_variation = ProductVariation.find(params[:id])
    @product = @product_variation.product
    if @product_variation.update(product_variation_params)
      redirect_to admin_products_path, notice: 'Product Variation updated successfully'
    else
      render file: 'products/edit_product_variation'
    end
  end
  def create
    @product = Product.find(params[:product_id])
    @product_variation = @product.product_variations.build(product_variation_params)
    if @product_variation.save
      redirect_to admin_products_path, notice: 'Product Variation created successfully'
    else
      render :new_product_variation
    end
  end

  def destroy
    @product_variation = ProductVariation.find(params[:id])
    @product_variation.destroy
    redirect_to admin_products_path, notice: 'Product Variation deleted successfully'
  end

private

  def product_variation_params
    params.require(:product_variation).permit(:specification, :quantity)
  end
end
