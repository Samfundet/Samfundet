# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::MenuCategory do
  it 'requires both translated titles and displays the selected locale' do
    category = build(:sulten_menu_category)
    I18n.with_locale(:no) { expect(category.to_s).to eq('Mat') }
    I18n.with_locale(:en) { expect(category.to_s).to eq('Food') }
    category.title_en = nil
    expect(category).not_to be_valid
  end
  it 'destroys menu items belonging to a deleted category' do
    item = create(:sulten_menu_item)
    expect { item.sulten_menu_category.destroy! }.to change(Sulten::MenuItem, :count).by(-1)
  end
end
