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
    render json: params, status: :created
  end
end
