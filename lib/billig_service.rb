# frozen_string_literal: true

require 'sinatra'
require 'pp'

class BilligService < Sinatra::Base
  post '/pay' do
    puts 'A payment request has been received, consisting of the following tickets.'
    puts

    tp params.map { |key, value|
      next unless /price_(\d+)_count/ =~ key
      price_group = BilligPriceGroup.find Regexp.last_match(1)

      {
        event: price_group.billig_ticket_group.billig_event.event_name,
        group: price_group.price_group_name,
        count: value
      }
    }.compact

    puts
    print 'Accept payment? (Y/n) '

    if $stdin.gets.chomp == 'n'
      puts
      puts 'Due to what kind of error?'
      puts '0. No error.'
      puts '1. Some database error.'
      puts '2. Some field error.'
      puts
      print 'Which error? (default 0) '

      bsession = SecureRandom.uuid

      case $stdin.gets.chomp.to_i
      when 1
        BilligPaymentError.create!(
          error: bsession,
          message: 'Some error occurred.'
        )

      when 2
        BilligPaymentError.create!(
          error: bsession,
          message: 'Some error occurred.',
          owner_cardno: params[:cardnumber],
          owner_email: params[:email]
        )

        params.each do |key, value|
          next unless /price_(\d+)_count/ =~ key
          price_group_id = Regexp.last_match(1)

          BilligPaymentErrorPriceGroup.create!(
            error: bsession,
            price_group: price_group_id,
            number_of_tickets: value
          )
        end
      end
      redirect 'http://localhost:3000/en/events/purchase_callback?bsession=' << bsession
    else
      tickets = []

      params.each do |key, value|
        next unless /price_(\d+)_count/ =~ key
        price_group_id = Regexp.last_match(1)

        value.to_i.times do
          ticket_id = (BilligTicket.pluck(:ticket).max || 0) + 1

          # This allows for all tickets on membership cards, while in reality,
          # only one ticket will be on the card.
          member_id = if params[:cardnumber].present?
                        BilligTicketCard.where(card: params[:cardnumber]).first.try(:owner_member_id)
                      end

          bp = BilligPurchase.create!(
            owner_member_id: member_id,
            owner_email: params[:email].present? ? params[:email] : nil
          )

          tickets << BilligTicket.create!(
            ticket: ticket_id,
            on_card: member_id.present?,
            price_group: price_group_id,
            purchase: bp.id
          )
        end
      end

      redirect 'http://localhost:3000/en/events/purchase_callback/' << tickets.map { |ticket| ticket.ticket.to_s << '12345' }.join(',')
    end
  end
end
