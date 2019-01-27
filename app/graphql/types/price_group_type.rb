# frozen_string_literal: true

module Types
  class PriceGroupType < GraphQL::Schema::Object
    field :name, String, null: false
    def name
      if object.instance_of? PriceGroup
        object.name
      elsif object.instance_of? BilligPriceGroup
        object.price_group_name
      end
    end

    field :price, Integer, null: false
  end
end
