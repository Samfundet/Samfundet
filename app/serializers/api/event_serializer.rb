# frozen_string_literal: true

class Api::EventSerializer < ActiveModel::Serializer
  attributes :id, :short_description
end
