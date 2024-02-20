# frozen_string_literal: true

class ProductsController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, Product, Order }
  def index
    @products = Product.includes(:product_variations)
                       .published
                       .where(has_variations: false)
                       .or(
                         Product.with_variations.published.where(has_variations: true)
                       )
    if @products.empty?
      render 'no_merch'
    end
  end

  def products_by_id
    id = params[:id]
    variation_id = params[:variation_id]

    product = Product.find(id)

    if variation_id
      variation = ProductVariation.find(variation_id)
      render json: { product: product, variation: variation, img: product.image_or_default }
    else
      render json: { product: product, img: product.image_or_default }
    end
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

  def show
    @product = Product.find(params[:id])
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

  def admin_applet
  end

private

  def product_params
    params.require(:product).permit(
      :name_no, :name_en,
      :price,
      :has_variations,
      :amount,
      :image_id,
      :release_time
    )
  end
end
