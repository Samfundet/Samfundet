# frozen_string_literal: true

class Tag < ActiveRecord::Base
  # attr_accessible :name
  has_and_belongs_to_many :images, uniq: true

  def self.by_images_count
    Tag.all.sort_by(&:images_count).reverse
  end

  delegate :count, to: :images, prefix: true
end

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
