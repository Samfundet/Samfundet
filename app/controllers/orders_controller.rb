# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource
  def admin
    @active_orders = Order.includes(order_products: %i[product product_variation]).where(processed: false)
    @order_history = Order.includes(order_products: %i[product product_variation]).where(processed: true)
  end

  def admin_confirm
    Order.find(params[:id]).update(processed: true)
    redirect_to admin_orders_path
  end

  def new
    @order = Order.new
  end

  def create
    order_params = JSON.parse(params['_json'])
    order = Order.new(name: order_params['name'], email: order_params['email'])

    order_params['products'].each do |product_params|
      product_id = product_params['product_id']
      product_variation_id = product_params['product_variation_id']
      amount = product_params['amount']

      order_product = OrderProduct.new(
        amount: amount,
        order: order,
        product_id: product_id,
        product_variation_id: product_variation_id
      )

      if product_variation_id
        product_variation = ProductVariation.find(product_variation_id)
        new_amount = product_variation.amount - amount
        if new_amount < 0
          flash[:error] = 'Not enough available products'
          render :new and return
        end
        product_variation.update(amount: product_variation.amount - amount)
      else
        product = Product.find(product_id)
        new_amount = product.amount - amount
        if new_amount < 0
          flash[:error] = 'Not enough available products'
          render :new and return
        end
        product.update(amount: product.amount - amount)
      end

      order_product.save
    end


    if order.save
      OrderConfirmationMailer.send_confirmation_mail(order).deliver
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path
  end
end
