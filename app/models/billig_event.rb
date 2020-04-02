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
