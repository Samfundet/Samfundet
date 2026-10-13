# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AdmissionsController, type: :controller do
  it 'lists open, upcoming and closed admissions separately' do
    open = create(:admission, is_primary: true)
    upcoming = create(:admission, shown_from: 2.days.from_now, is_primary: true)
    past = create(:admission, :past, is_primary: true)
    get :index
    expect(assigns(:open_admissions)).to include(open)
    expect(assigns(:upcoming_admissions)).to include(upcoming)
    expect(assigns(:closed_admissions)).to include(past)
    expect(response).to render_template(:index)
  end
  it 'shows an open admission to a guest' do
    admission = create(:admission)
    get :show_public, params: { id: admission.id }
    expect(assigns(:admission)).to eq(admission)
  end
  it 'rejects requests for closed admissions' do
    admission = create(:admission, :past)
    expect { get :show_public, params: { id: admission.id } }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
