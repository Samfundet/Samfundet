# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::ReservationsController, type: :controller do
  let(:type) { create(:sulten_reservation_type) }
  let(:table) { create(:sulten_table) }
  let(:date) { 2.days.from_now.to_date.to_s }
  let(:attrs) { { reservation_from: date, reservation_duration: '18:00', people: 2, reservation_type_id: type.id, name: 'Ola Nordmann', email: 'ola@example.com', telephone: '12345678', gdpr_checkbox: '1' } }
  before { Sulten::TableReservationType.create!(table: table, reservation_type: type) }
  it 'reserves an available table and sends confirmation' do
    expect { post :create, params: { sulten_reservation: attrs } }.to change(Sulten::Reservation, :count).by(1)
    expect(Sulten::Reservation.last.table).to eq(table)
    expect(ActionMailer::Base.deliveries.last.to).to eq(['ola@example.com'])
    expect(response).to redirect_to(sulten_reservation_success_path)
  end
  it 'rejects bookings made for today' do
    expect { post :create, params: { sulten_reservation: attrs.merge(reservation_from: Date.current.to_s) } }.not_to change(Sulten::Reservation, :count)
    expect(response).to redirect_to(sulten_reservation_failure_day_path)
  end
  it 'rejects bookings during closed periods' do
    create(:sulten_closed_period, closed_from: 1.day.from_now, closed_to: 4.days.from_now)
    post :create, params: { sulten_reservation: attrs }
    expect(response).to redirect_to(sulten_reservation_failure_path)
  end
  it 'rejects bookings when no suitable table is available' do
    table.update!(available: false)
    post :create, params: { sulten_reservation: attrs }
    expect(response).to redirect_to(sulten_reservation_failure_path)
  end
  it 'does not persist invalid public bookings' do
    expect { post :create, params: { sulten_reservation: attrs.merge(email: 'invalid') } }.not_to change(Sulten::Reservation, :count)
    expect(response).to redirect_to(sulten_reservation_failure_path)
  end
  context 'as an administrator' do
    let(:reservation) { create(:sulten_reservation, table: table, reservation_type: type) }
    before do
      member = create(:member)
      member.roles << Role.super_user
      login_member(member)
    end
    %i[index archive new admin_new show edit].each do |action|
      it "loads #{action} without errors" do
        get action, params: { id: reservation.id }
        expect(response).to have_http_status(:ok)
      end
    end
    it 'exports reservations as CSV' do
      reservation
      get :export, format: :csv
      expect(response.headers['Content-Disposition']).to include('Reservasjon.csv')
    end
    it 'creates manual reservations without emailing the customer' do
      attrs = attributes_for(:sulten_reservation).except(:admin_access).merge(table_id: table.id, reservation_type_id: type.id, reservation_duration: 120)
      expect { post :admin_create, params: { sulten_reservation: attrs } }.not_to change { ActionMailer::Base.deliveries.count }
      expect(assigns(:reservation)).to be_persisted
      expect(assigns(:reservation).telephone).to eq('N/A')
      expect(response).to redirect_to(sulten_admin_path)
    end
    it 'renders errors for invalid manual bookings' do
      post :admin_create, params: { sulten_reservation: { reservation_from: date, reservation_duration: 45 } }
      expect(response).to render_template(:admin_new)
    end
    it 'updates reservations while recalculating the end time' do
      patch :update, params: { id: reservation.id, sulten_reservation: { name: 'Changed', reservation_duration: 60 } }
      expect(reservation.reload.name).to eq('Changed')
      expect(reservation.reservation_to).to eq(reservation.reservation_from + 1.hour)
      expect(response).to redirect_to(reservation)
    end
    it 'preserves names when an invalid update is submitted' do
      name = reservation.name
      patch :update, params: { id: reservation.id, sulten_reservation: { name: '' } }
      expect(reservation.reload.name).to eq(name)
      expect(response).to render_template(:edit)
    end
    it 'deletes a reservation' do
      reservation
      expect { delete :destroy, params: { id: reservation.id } }.to change(Sulten::Reservation, :count).by(-1)
      expect(response).to redirect_to(sulten_reservations_archive_path)
    end
  end
end
