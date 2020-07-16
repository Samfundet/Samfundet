# frozen_string_literal: true

class RegistrationEvent < ApplicationRecord
    RegistrationEvent.establish_connection(:paamelding)
    RegistrationEvent.table_name = 'paameldingsys.arrangementer'
    belongs_to :arrangement, class_name: :Event

    def slots
        return plasser.to_s + "/" + RegistrationEvent.connection.exec_query('SELECT * FROM paameldingsys.arrangementer WHERE arrangement_id=%d;' % arrangement_id).to_a[0]["plasser"].to_s + " plasser"
      end
    #has_one :arrangement, class_name: :Event
    # attr_accessible :a4_ticket_layout, :dave_id, :dave_time_id, :event_location, :event_name, :event_note, :event_time, :event_type, :external_id, :organisation, :receipt_ticket_layout, :sale_from, :sale_to, :tp_ticket_layout, :hidden
  end
  
  # == Schema Information
  #
  # Table name: billig_events
  #
  #  event                 :bigint           not null, primary key
  #  a4_ticket_layout      :integer
  #  dave_id               :integer
  #  dave_time_id          :integer
  #  event_location        :string
  #  event_name            :string
  #  event_note            :string
  #  event_time            :datetime
  #  event_type            :string
  #  external_id           :integer
  #  organisation          :integer
  #  receipt_ticket_layout :integer
  #  sale_from             :datetime
  #  sale_to               :datetime
  #  tp_ticket_layout      :integer
  #  created_at            :datetime         not null
  #  updated_at            :datetime         not null
  #  hidden                :boolean
  #
  