# frozen_string_literal: true

class OrderConfirmationMailer < ActionMailer::Base
  default from: 'mg-web@samfundet.no',
          reply_to: 'snorrekr@samfundet.no'

  def send_confirmation_mail(order)
    @order = order
    mail(to: @order.epost, subject: 'Verify your order') do |format|
      format.html { render 'orders/order_confirmation_mail', order: @order }
    end
  end
end
