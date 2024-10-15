# frozen_string_literal: true

class Sulten::MenuItem < ApplicationRecord
  belongs_to :sulten_menu_category, class_name: 'Sulten::MenuCategory', foreign_key: 'category_id'

  validates :title_no, :title_en, :description_no, :description_en,
            :allergies_no, :allergies_en, :price, :price_member, :category_id,
            presence: true

  extend LocalizedFields
  localized_fields :title, :description, :allergies, :additional_info
end
