# frozen_string_literal: true

class Image < ApplicationRecord
  DEFAULT_TITLE = 'Default image'
  DEFAULT_PATH = Rails.root.join('app', 'assets', 'images',
                                 'banner-images', 'kitteh.jpeg')
  # attr_accessible :title, :image_file, :uploader_id, :tagstring, :uploader

  has_attached_file :image_file,
                    styles: { medium: 'x180>', large: 'x400>' },
                    convert_options: { medium: '-quality 80', large: '-quality 80' },
                    processors: %i[thumbnail compression],
                    url: '/upload/:class/:attachment/:id_partition/:style/:filename',
                    path: ':rails_root/public/upload/:class/:attachment/:id_partition/:style/:filename',
                    default_url: '/home/aleksanb/Projects/Samfundet3/app/assets/images/banner-images/kitteh.jpeg'

  validates :title, uniqueness: true, presence: true
  validates :image_file, presence: true

  validates_attachment :image_file,
                       presence: true,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png'] }

  has_and_belongs_to_many :tags, uniq: true
  has_many :events
  belongs_to :uploader, class_name: 'Member', foreign_key: :uploader_id

  before_destroy { |image| image.events.clear }

  default_scope { order(image_file_updated_at: :desc) }

  include PgSearch
  pg_search_scope :search,
                  against: %i[title
                              image_file_file_name
                              image_file_content_type],
                  using: { tsearch: { dictionary: 'english' } },
                  associated_against: { tags: :name }

  def tagstring=(new_tagstring)
    new_tags = new_tagstring.split(', ').map do |tag|
      Tag.find_or_create_by(name: tag.downcase)
    end

    self.tags = new_tags
  end

  def tagstring
    tags.map(&:name).join ', '
  end

  def self.image_or_default(id)
    return default_image.image_file if id.nil?

    image = find(id)
    if image.present?
      image.image_file
    else
      default_image.image_file
    end
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      Image.all
    end
  end

  def self.default_image
    find_or_create_by title: DEFAULT_TITLE do |image|
      image.image_file = File.open(DEFAULT_PATH)
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

  def self.image_for(o)
    o.try(:image) || Image.default_image
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: images
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  image_file_file_name    :string(255)
#  image_file_content_type :string(255)
#  image_file_file_size    :integer
#  image_file_updated_at   :datetime
#
