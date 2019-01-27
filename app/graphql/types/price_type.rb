# frozen_string_literal: true

module Types
  class PriceType < Bases::BaseEnum
    graphql_name 'PriceType'
  end
end

Event::PRICE_TYPE.each do |price_type|
  Types::PriceType.value(price_type.upcase, price_type, value: price_type)
end
