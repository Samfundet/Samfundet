# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :author, class_name: 'Member'
  belongs_to :image
  has_one :front_page_lock, as: :lockable

  # attr_accessible :title_no, :title_en, :lead_paragraph_no, :lead_paragraph_en, :content_no, :content_en, :publish_at, :published, :author_id, :image_id

  validates :title_no, :title_en, :lead_paragraph_no, :lead_paragraph_en, :content_no, :content_en, :publish_at, :author_id, :image_id, presence: true

  scope :published, -> { where('publish_at < ?', Time.current).where(published: true) }

  extend LocalizedFields
  localized_fields :title, :lead_paragraph, :content

  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end

  def to_s
    title
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end
end

# == Schema Information
#
# Table name: blogs
#
#  id                :bigint           not null, primary key
#  title_no          :string
#  content_no        :text
#  author_id         :integer
#  published         :boolean
#  publish_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_id          :integer
#  lead_paragraph_no :text
#  title_en          :string
#  lead_paragraph_en :text
#  content_en        :text
#
