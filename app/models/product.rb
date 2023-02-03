# frozen_string_literal: true

class Product < ApplicationRecord
  extend LocalizedFields
  localized_fields :name
  validates :name_no, :name_en, :price, presence: true

  belongs_to :image
  has_many :product_variations

  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end

  def to_s
    name
  end
end
