# frozen_string_literal: true

class CustomRoute < ApplicationRecord
  validates :source, presence: true, uniqueness: true
  validates :target, presence: true
end
