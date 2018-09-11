module Api
  class EventSerializer < ActiveModel::Serializer
    attributes :id, :short_description
  end
end
