# frozen_string_literal: true

class CustomConnection < GraphQL::Types::Relay::BaseConnection
  field :total_count, Integer, 'The total count of nodes.', null: false

  def total_count
    object.nodes.size
  end
end

module Types
  module Bases
    class BaseObject < GraphQL::Schema::Object
      connection_type_class CustomConnection
      field :id, ID, 'The ID of the requested resource', null: false
    end
  end
end
