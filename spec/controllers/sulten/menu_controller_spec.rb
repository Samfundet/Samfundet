# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Sulten::MenuController, type: :controller do
  it 'lists categories and their items for restaurant staff' do
    member = create(:member, :with_role, role_title: 'ksg_sulten')
    login_member(member)
    item = create(:sulten_menu_item)
    get :index
    expect(assigns(:categories)).to contain_exactly(item.sulten_menu_category)
    expect(assigns(:items)).to contain_exactly(item)
  end
  it 'denies guests access to menu administration' do
    get :index
    expect(response).to be_redirect
  end
end
