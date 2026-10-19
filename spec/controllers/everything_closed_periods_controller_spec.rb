# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EverythingClosedPeriodsController, type: :controller do
  let(:record) { create(:everything_closed_period) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'prepares a new record for the form' do
    get :new
    expect(assigns(:everything_closed_period)).to be_new_record
    expect(response).to render_template('new')
  end
  it 'loads the requested record for editing' do
    get :edit, params: { id: record.id }
    expect(assigns(:everything_closed_period)).to eq(record)
  end
  it 'persists valid submitted attributes' do
    attributes = attributes_for(:everything_closed_period)

    expect { post :create, params: { everything_closed_period: attributes } }.to change(EverythingClosedPeriod, :count).by(1)
    expect(response).to redirect_to(everything_closed_periods_path)
  end
  it 'renders errors without persisting an invalid record' do
    attributes = attributes_for(:everything_closed_period).merge({ message_en: '' })

    expect { post :create, params: { everything_closed_period: attributes } }.not_to change(EverythingClosedPeriod, :count)
    expect(response).to render_template('new')
  end
  it 'updates saved attributes' do
    patch :update, params: { id: record.id, everything_closed_period: { message_en: 'Updated' } }
    expect(record.reload.message_en).to eq('Updated')
    expect(response).to redirect_to(everything_closed_periods_path)
  end
  it 'preserves the persisted record on invalid updates' do
    original = record.attributes
    patch :update, params: { id: record.id, everything_closed_period: { message_en: '' } }
    expect(record.reload.attributes).to eq(original)
    expect(response).to render_template('edit')
  end
  it 'deletes the requested record' do
    record
    expect { delete :destroy, params: { id: record.id } }.to change(EverythingClosedPeriod, :count).by(-1)
    expect(response).to redirect_to(everything_closed_periods_path)
  end
end
