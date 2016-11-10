require "rails_helper"

describe GroupsController do
  let(:user) { create(:member) }
  before do
    role = Role.super_user
    user.roles << role
    login_member(user)
  end

  describe "GET #admin" do
    it "renders the admin template" do
      get :admin

      expect(response).to render_template(:admin)
    end
    it "assigns @group_types to all" do
      group_types = create_list(:group_type, 5)

      get :admin

      expect(assigns(:group_types)).to eq group_types
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new

      expect(response).to render_template(:new)
    end

    it "assigns @group to a new record" do
      get :new

      expect(assigns(:group)).to be_new_record
    end
  end

  describe "POST #create" do
    let(:group_type) { create(:group_type) }
    let(:valid_attributes) { attributes_for(:group, group_type_id: group_type.id) }
    let(:invalid_attributes) { attributes_for(:group, name: '', group_type_id: group_type.id) }
    context "with valid attributes" do
      it "saves the new group" do
        expect do
          post :create, params: { group: valid_attributes }
        end.to change(Group, :count).by(1)
      end
      it "redirects to the group index" do
        post :create, params: { group: valid_attributes }
        expect(response).to redirect_to admin_groups_path
      end
      it "displays flash success" do
        post :create, params: { group: valid_attributes }
        expect(flash[:success]).to match("Gjengen er opprettet")
      end
    end

    context "with invalid attributes" do
      it "does not save the new group" do
        expect do
          post :create, params: { group: invalid_attributes }
        end.to_not change(Group, :count)
      end
      it "re-renders the new template" do
        post :create, params: { group: invalid_attributes }
        expect(response).to render_template :new
      end
      it "displays flash error" do
        post :create, params: { group: invalid_attributes }
        expect(flash[:error]).to match(I18n.t('common.fields_missing_error'))
      end
    end
  end

  describe "GET #edit" do
    let(:group) { create(:group) }

    it "renders the edit view" do
      get :edit, params: { id: group.id }

      expect(response).to render_template(:edit)
    end

    it "assigns @group" do
      get :edit, params: { id: group.id }

      expect(assigns(:group)).to eq group
    end
  end

  describe "POST #update" do
    let(:group) { create(:group) }
    let(:group_type) { create(:group_type) }
    let(:valid_attributes) { attributes_for(:group, group_type_id: group_type.id) }
    let(:invalid_attributes) { attributes_for(:group, name: '', group_type_id: group_type.id) }
    context "with valid attributes" do
      it "assigns @group" do
        put :update, params: { id: group.id, group: valid_attributes }

        expect(assigns(:group)).to eq group
      end
      it "updates group's attributes" do
        attributes = attributes_for(:group, name: "Some name", abbreviation: "sm")
        post :update, params: { id: group.id, group: attributes }
        group.reload
        expect(group.name).to eq "Some name"
        expect(group.abbreviation).to eq "sm"
      end
      it "redirects to the group index" do
        post :update, params: { id: group.id, group: valid_attributes }
        expect(response).to redirect_to admin_groups_path
      end
      it "displays flash success" do
        post :update, params: { id: group.id, group: valid_attributes }
        expect(flash[:success]).to match("Gjengen er oppdatert")
      end
    end

    context "with invalid attributes" do
      it "assigns @group" do
        post :update, params: { id: group.id, group: invalid_attributes }
        expect(assigns(:group)).to eq group
      end
      it "does not save the new group" do
        attributes = attributes_for(:group, name: "", abbreviation: "sm")
        post :update, params: { id: group.id, group: attributes }
        group.reload
        expect(group.name).to_not eq ""
        expect(group.abbreviation).to_not eq "sm"
      end
      it "re-renders the new template" do
        post :update, params: { id: group.id, group: invalid_attributes }
        expect(response).to render_template :edit
      end
      it "displays flash error" do
        post :create, params: { id: group.id, group: invalid_attributes }
        expect(flash[:error]).to match(I18n.t('common.fields_missing_error'))
      end
    end
  end
end
