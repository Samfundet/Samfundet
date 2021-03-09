class InfoBox < ApplicationRecord
  COLOR = %w[blue red white green].freeze

  extend LocalizedFields
  localized_fields :title, :body, :link

  validates :title_no, :title_en, :body_no, :body_en, :bg_color, presence: true

  belongs_to :image
  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end
end
