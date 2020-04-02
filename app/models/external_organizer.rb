# frozen_string_literal: true

class ExternalOrganizer < ApplicationRecord
  has_many :events, as: :organizer
end

# == Schema Information
#
# Table name: external_organizers
#
#  id   :bigint           not null, primary key
#  name :string
#
