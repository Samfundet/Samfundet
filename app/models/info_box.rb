class InfoBox < ApplicationRecord

  validates :title, presence: true
  validates :body, presence: true
  validates :image_id, presence: true

  belongs_to :image
  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end
end
