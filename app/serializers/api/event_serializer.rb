# frozen_string_literal: true

class Api::EventSerializer < ActiveModel::Serializer
  attributes *Event.column_names
end
