# frozen_string_literal: true

class MerchController < ApplicationController
  skip_authorization_check

  def index
    @products = Product.includes(:product_variants)
  end
end
