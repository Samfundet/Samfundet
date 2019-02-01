
# frozen_string_literal: true

require 'rails_helper'

describe 'controllers' do
  describe SiteController, type: :controller do
    describe 'GET index' do
      it 'returns 200 Success' do
        get :index
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe AdmissionsAdmin::AdmissionsController, type: :controller do
    let(:member) { create(:member) }
    let(:admission) { create(:admission) }

    before do
      login_member(member)
    end

    describe 'GET show' do
      it 'returns unauthorized' do
        get :show, params: { id: admission.id }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe MembersController, type: :feature do
    let(:member) { create(:member) }
    test_term = '123'
    describe 'GET search' do
      it 'returns unauthorized for guests' do
      end

      it 'returns unauthorized for regular users' do
        visit members_search_path({ format: :json, params: { term: 'ASDFFFF' }})
        expect(page).to have_http_status(302)
      end
    end
  end
end
