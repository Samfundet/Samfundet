# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Sulten::TablesController, type: :controller do
  let(:table) { create(:sulten_table) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'lists tables and neighbour relations' do
    table
    get :index
    expect(assigns(:tables)).to contain_exactly(table)
    expect(assigns(:neighbour_relations)).to be_empty
  end
  it 'loads a table for display' do
    get :show, params: { id: table.id }
    expect(assigns(:table)).to eq(table)
  end
  it 'excludes the edited table from neighbour choices' do
    other = create(:sulten_table)
    get :edit, params: { id: table.id }
    expect(assigns(:other_tables)).to contain_exactly(other)
  end
  it 'prepares a new table with existing neighbour choices' do
    table
    get :new
    expect(assigns(:table)).to be_new_record
    expect(assigns(:other_tables)).to contain_exactly(table)
  end
  it 'creates a table and its selected neighbour relationship' do
    neighbour = table
    expect { post :create, params: { sulten_table: attributes_for(:sulten_table), is_neighbour: { neighbour.id.to_s => '1' } } }.to change(Sulten::Table, :count).by(1)
    expect(assigns(:table).neighbours).to eq([neighbour])
    expect(response).to redirect_to(assigns(:table))
  end
  it 'rejects tables with missing capacity' do
    expect { post :create, params: { sulten_table: { number: 5 } } }.not_to change(Sulten::Table, :count)
    expect(response).to render_template(:new)
  end
  it 'updates table capacity and adds neighbours without duplicate relations' do
    neighbour = create(:sulten_table)
    patch :update, params: { id: table.id, sulten_table: { capacity: 8 }, is_neighbour: { neighbour.id.to_s => '1' } }
    expect(table.reload.capacity).to eq(8)
    expect(table.neighbours).to eq([neighbour])
    expect { patch :update, params: { id: table.id, sulten_table: { capacity: 8 }, is_neighbour: { neighbour.id.to_s => '1' } } }.not_to change(Sulten::NeighbourTable, :count)
  end
  it 'removes deselected neighbour relations in either direction' do
    left = create(:sulten_table)
    right = create(:sulten_table)
    Sulten::NeighbourTable.create!(table: left, neighbour: table)
    Sulten::NeighbourTable.create!(table: table, neighbour: right)
    expect { patch :update, params: { id: table.id, sulten_table: { capacity: 4 } } }.to change(Sulten::NeighbourTable, :count).by(-2)
  end
  it 'renders errors when the capacity is cleared' do
    patch :update, params: { id: table.id, sulten_table: { capacity: nil } }
    expect(response).to render_template(:edit)
    expect(table.reload.capacity).to eq(4)
  end
  it 'deletes tables and their neighbour relations' do
    table
    expect { delete :destroy, params: { id: table.id } }.to change(Sulten::Table, :count).by(-1)
  end
end
