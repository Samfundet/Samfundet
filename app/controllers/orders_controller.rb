# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource
  def admin
    @orders = Order.includes(order_products: %i[product product_variation]).all
  end

  def new
    @order = Order.new
  end

  def create
    order_params = JSON.parse(params['_json'])
    order = Order.new(name: order_params['name'], epost: order_params['epost'])

    if order.save
      order_params['products'].each do |product_params|
        order_product = OrderProduct.new(
          amount: product_params['amount'],
          order: order,
          product_id: product_params['product_id'],
          product_variation_id: product_params['product_variation_id']
        )
        order_product.save
      end
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @supporter = Order.find(params[:id])
    @supporter.destroy
    redirect_to admin_orders_path
  end
end
