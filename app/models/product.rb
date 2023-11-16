# frozen_string_literal: true

class Product < ApplicationRecord
  extend LocalizedFields
  localized_fields :name
  validates :name_no, :name_en, :price, :image_id, :release_time, presence: true

  belongs_to :image
  has_many :product_variations, dependent: :destroy
  has_many :order_products, dependent: :destroy

  scope :published, -> { where('release_time < ?', Time.current) }
  scope :with_variations, -> { includes(:product_variations).where.not(product_variations: { id: nil }) }

  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end

  def get_amount
    if has_variations
      product_variations.sum(:amount)
    else
      amount
    end
  end

  def filtered_product_variations(variation_id)
    product_variations.where(id: variation_id)
  end

  def to_s
    name
  end
end
