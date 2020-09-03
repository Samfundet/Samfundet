# frozen_string_literal: true

class RegistrationEvent < ApplicationRecord
  RegistrationEvent.establish_connection(:paamelding)
  RegistrationEvent.table_name = 'paameldingsys.arrangementer'
  belongs_to :arrangement, class_name: :Event

  def registrations
    # Return 0 if in development, elsewise return how many registrations the event has
    if Rails.env.development?
      0
    else
      RegistrationEvent.connection.exec_query('SELECT * FROM paameldingsys.lim_paameldingsinfo WHERE arrangement_id=%d;' % arrangement_id).to_a[0]['paameldinger']
    end
  end

  def link
    'https://medlem.samfundet.no/account/paamelding?id=%d' % [arrangement_id]
  end


  def full?
    if !registrations.nil? && !plasser.nil?
      return registrations >= plasser
    end
    false
  end
end

# == Schema Information
#
# Table name: billig_events
#
#  arrangement_id                 :int           not null, primary key, foreign key
#  plasser      :integer
#  paameldinger(only selectable from view lim_paameldingsinfo)               :integer
