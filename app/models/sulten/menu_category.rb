# frozen_string_literal: true

class Sulten::MenuCategory < ApplicationRecord
  has_many :sulten_menu_items, class_name: 'Sulten::MenuItem', foreign_key: 'category_id', dependent: :destroy

  validates :title_no, :title_en, presence: true

  extend LocalizedFields
  localized_fields :title

  def to_s
    title
  end
end
