# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Tag do
  it 'orders tags by the number of associated images' do
    image = create(:image)
    used = Tag.create!(name: 'Music')
    unused = Tag.create!(name: 'Unused')
    used.images << image
    expect(used.images_count).to eq(1)
    expect(Tag.by_images_count).to eq([used, unused])
  end
end
