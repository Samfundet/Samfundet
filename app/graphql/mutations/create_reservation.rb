# frozen_string_literal: true

class Mutations::CreateReservation < GraphQL::Schema::Mutation
  null true

  argument :reservation_input, Types::Inputs::ReservationInput, required: true, description: 'A table reservation'

  description 'Create a reservation.'

  field :success, Boolean, null: false
  field :errors, Types::JsonType, null: true

  def resolve(reservation_input:)
    e = Sulten::Reservation.new(reservation_input.to_h)
    if e.save
      {
        reservation: e,
        success: true
      }
    else
      {
        success: false,
        errors: e.errors.to_hash
      }
    end
  end
end
