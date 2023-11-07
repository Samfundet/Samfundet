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
      product_variations.sum(:quantity)
    else
      amount
    end
  end

  def to_s
    name
  end
end
