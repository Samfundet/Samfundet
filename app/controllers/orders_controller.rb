# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource
  def admin
    @orders = Order.includes(:order_product)
  end

  def new
    @order = Order.new
  end

  def create
    render json: params
  end
end
