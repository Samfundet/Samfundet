# frozen_string_literal: true

class ExternalOrganizer < ActiveRecord::Base
  has_many :events, as: :organizer
end
