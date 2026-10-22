# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AreasController, type: :controller do
  let(:area) { create(:area) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'loads all areas and the requested area for editing' do
    area
    get :edit, params: { id: area.id }
    expect(assigns(:area)).to eq(area)
    expect(assigns(:areas)).to contain_exactly(area)
  end
  it 'updates opening hours through nested attributes' do
    patch :update, params: { id: area.id, area: { standard_hours_attributes: [{ day: 'monday', open: false }] } }
    expect(area.standard_hours.first.day).to eq('monday')
    expect(response).to redirect_to(edit_area_path(area))
  end
  it 'rejects invalid opening weekdays' do
    patch :update, params: { id: area.id, area: { standard_hours_attributes: [{ day: 'invalid', open: false }] } }
    expect(area.standard_hours).to be_empty
    expect(response).to render_template(:edit)
  end
  it 'lists areas in the opening hours applet' do
    area
    controller.edit_opening_hours_applet
    expect(assigns(:areas)).to contain_exactly(area)
  end
end
