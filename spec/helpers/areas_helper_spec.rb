# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AreasHelper, type: :helper do
  it 'links an area with a page to that page' do
    page = Page.new(name_no: 'cafe', name_en: 'cafe')
    area = Area.new(name: 'Cafe', page: page)
    expect(helper).to receive(:link_to).with('Cafe', page).and_return('page link')
    expect(helper.area_link(area)).to eq('page link')
  end
  it 'links Lyche to the restaurant page when no page is assigned' do
    expect(helper.area_link(Area.new(name: 'Lyche'))).to eq(helper.link_to('Lyche', helper.sulten_path))
  end
  it 'uses a supplied label or the plain name when no page exists' do
    expect(helper.area_link(Area.new(name: 'Cafe'))).to eq('Cafe')
    expect(helper.area_link(Area.new(name: 'Cafe'), 'Custom')).to eq('Custom')
  end
end
