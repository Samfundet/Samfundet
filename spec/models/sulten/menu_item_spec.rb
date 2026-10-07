# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::MenuItem do
  %i[title_no title_en description_no description_en allergens_no allergens_en price price_member category_id].each do |field|
    it "requires #{field}" do
      item = build(:sulten_menu_item)
      item.public_send("#{field}=", nil)
      expect(item).not_to be_valid
      expect(item.errors[field]).to be_present
    end
  end
  it 'localizes descriptions and allergens' do
    item = build(:sulten_menu_item)
    I18n.with_locale(:en) do
      expect(item.description).to eq('Good soup')
      expect(item.allergens).to eq('Milk')
    end
  end
end
