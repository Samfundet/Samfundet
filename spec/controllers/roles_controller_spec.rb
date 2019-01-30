# frozen_string_literal: true

require 'rails_helper'

describe RolesController do
  let(:user) { create(:member) }

  # let(:parent_role) { create(:role)}
  # let(:child_role) { create(:role, role_id: parent_role.id)}
  context 'logged in as regular user with some roles' do
    before do
      @parent_role = create(:role)
      @child_role = create(:role, role_id: @parent_role.id)
      user.roles << @parent_role
      login_member(user)
    end

    describe 'GET #index' do
      it 'renders the index layout' do
        get :index

        expect(response).to render_template(:index)
      end

      it 'assigns @roles' do
        get :index

        expect(assigns(:roles)).to match([@child_role])
      end
    end

    describe 'GET #show' do
      it 'renders the show layout' do
        get :show, params: { id: @parent_role.id, locale: 'en' }

        expect(response).to render_template(:show)
      end
    end
  end
  context 'logged in as super user' do
    before do
      user.roles << Role.super_user
      login_member(user)
    end
    describe 'GET #new' do
      it 'renders to new layout' do
        get :new

        expect(response).to render_template(:new)
      end

      it 'assigns @role to a new record' do
        get :new

        expect(assigns(:role)).to be_new_record
      end
    end
    describe 'POST #create' do
      context 'with valid attributes' do
        let(:valid_attributes) { attributes_for(:role) }

        it 'saves the new role' do
          expect do
            post :create, params: { role: valid_attributes }
          end.to change(Role, :count).by(1)
        end

        it 'redirects to role path' do
          post :create, params: { role: valid_attributes }

          expect(response).to redirect_to(role_path(assigns(:role).id))
        end

        it 'displays flash success' do
          post :create, params: { role: valid_attributes }

          expect(flash[:success]).to match(I18n.t('roles.role_created'))
        end
      end
      context 'with invalid attributes' do
        let(:invalid_attributes) { attributes_for(:role, name: '') }

        it 'saves the new role' do
          expect do
            post :create, params: { role: invalid_attributes }
          end.not_to change(Role, :count)
        end

        it 'render the new template' do
          post :create, params: { role: invalid_attributes }

          expect(response).to render_template(:new)
        end

        it 'displays flash success' do
          post :create, params: { role: invalid_attributes }

          expect(flash[:error]).to match(I18n.t('common.fields_missing_error'))
        end
      end
    end

    describe 'GET #edit' do
      let(:role) { create(:role) }

      it 'renders the edit template' do
        get :edit, params: { id: role.id }

        expect(response).to render_template(:edit)
      end

      it 'assigns @role' do
        get :edit, params: { id: role.id }

        expect(assigns(:role)).to eq role
      end
    end

    describe 'POST #update' do
      let(:role) { create(:role) }

      context 'with valid attributes' do
        let(:valid_attributes) { attributes_for(:role, name: 'foobar') }

        it 'assigns @role' do
          post :update, params: { id: role.id, role: valid_attributes }

          expect(assigns(:role)).to eq role
        end

        it 'updates role attributes' do
          post :update, params: { id: role.id, role: valid_attributes }

          role.reload
          expect(role.name).to eq 'foobar'
        end

        it 'redirects to the role path' do
          post :update, params: { id: role.id, role: valid_attributes }

          expect(response).to redirect_to(role_path(role))
        end

        it 'displays flash success' do
          post :update, params: { id: role.id, role: valid_attributes }

          expect(flash[:success]).to eq 'Rollen er oppdatert.'
        end
      end
      context 'without valid attributes' do
        let(:invalid_attributes) { attributes_for(:role, name: '', description: 'This is a desc') }

        it 'assigns @role' do
          post :update, params: { id: role.id, role: invalid_attributes }

          expect(assigns(:role)).to eq role
        end

        it 'does not updates role attributes' do
          post :update, params: { id: role.id, role: invalid_attributes }

          role.reload
          expect(role.name).not_to eq 'foobar'
          expect(role.description).not_to eq 'This is a desc'
        end

        it 'redirects to the role path' do
          post :update, params: { id: role.id, role: invalid_attributes }

          expect(response).to render_template(:edit)
        end

        it 'displays flash error' do
          post :update, params: { id: role.id, role: invalid_attributes }

          expect(flash[:error]).to eq I18n.t('common.fields_missing_error')
        end
      end
    end
  end
  context 'logged in as regular user with passable role' do
    let(:member) { create(:member) }

    before do
      @role = create(:role, :passable)
      user.roles << @role
      login_member(user)
    end

    describe 'POST #pass' do
      it 'assigns @role' do
        post :pass, params: { id: @role.id, member_id: member.id }

        expect(assigns(:role)).to eq @role
      end

      it 'redirects to members controll panel' do
        post :pass, params: { id: @role.id, member_id: member.id }

        expect(response).to redirect_to members_control_panel_path
      end

      it 'passes the role' do
        post :pass, params: { id: @role.id, member_id: member.id }

        expect(member.roles).to include(@role)
      end

      it 'removes the role from the current user' do
        post :pass, params: { id: @role.id, member_id: member.id }
        user.reload

        expect(user.roles).not_to include(@role)
      end
    end
  end
end
