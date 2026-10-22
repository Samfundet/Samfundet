# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewBuildingController, type: :controller do
  it 'shows the new building page to guests' do
    get :index
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
  end
end
