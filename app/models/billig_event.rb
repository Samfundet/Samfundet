# frozen_string_literal: true

class BilligEvent < ApplicationRecord
  has_one :samfundet_event, class_name: 'Event'
  has_many :billig_ticket_groups, foreign_key: :event

  scope :sale_applicable, -> { where("hidden = 'f' AND sale_to > ?", Time.current) }

  self.primary_key = :event
  # attr_accessible :a4_ticket_layout, :dave_id, :dave_time_id, :event_location, :event_name, :event_note, :event_time, :event_type, :external_id, :organisation, :receipt_ticket_layout, :sale_from, :sale_to, :tp_ticket_layout, :hidden

  def describe
    I18n.l(event_time, format: :short) + ' - ' + event_name
  end

  def netsale_billig_ticket_groups
    billig_ticket_groups.select { |btg| btg.billig_price_groups.any?(&:netsale) }
  end

  def ticket_limit?
    billig_ticket_groups.any? { |t| t.ticket_limit? && t.tickets_left? }
  end
end
