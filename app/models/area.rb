# frozen_string_literal: true

class Area < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :page

  has_many :standard_hours

  accepts_nested_attributes_for :standard_hours

  default_scope { includes(:page) }

  def today
    standard_hours.today.first
  end

  def week
    StandardHour::WEEKDAYS.map do |day|
      standard_hours.find { |o| o.day == day } || standard_hours.build(day: day)
    end
  end

  def to_s
    name
  end

  def edit_path
    edit_area_path(self)
  end
end

# == Schema Information
#
# Table name: areas
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  page_id     :integer
#
