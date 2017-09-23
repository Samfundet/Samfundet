require 'sinatra'
require 'pp'

class BilligService < Sinatra::Base
  callback_path = if I18n.locale == :en
                    then 'http://localhost:3000/en/events/purchase_callback' 
                    else 'http://localhost:3000/arrangement/purchase_callback' end
  always_accept = false
  post '/pay' do
    puts 'A payment request has been received, consisting of the following tickets.'
    puts

    tp params.map { |key, value|
      if /price_(\d+)_count/ =~ key
        price_group = BilligPriceGroup.find $1

        {
          event: price_group.billig_ticket_group.billig_event.event_name,
          group: price_group.price_group_name,
          count: value
        }
      end
    }.compact

    puts
    print 'Accept payment? (Y/n) '

    if !always_accept and $stdin.gets.chomp == 'n'
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

        redirect callback_path << '?bsession=' << bsession
      when 2
        BilligPaymentError.create!(
          error: bsession,
          message: 'Some error occurred.',
          owner_cardno: params[:cardnumber],
          owner_email: params[:email]
        )

        params.each do |key, value|
          if /price_(\d+)_count/ =~ key
            price_group_id = $1

            BilligPaymentErrorPriceGroup.create!(
              error: bsession,
              price_group: price_group_id,
              number_of_tickets: value
            )
          end
        end

        redirect callback_path << '?bsession=' << bsession
      else
        redirect callback_path << '?bsession=' << bsession
      end
    else
      tickets = []

      params.each do |key, value|
        if /price_(\d+)_count/ =~ key
          price_group_id = $1

          value.to_i.times do
            ticket_id = (BilligTicket.pluck(:ticket).max || 0) + 1

            # This allows for all tickets on membership cards, while in reality,
            # only one ticket will be on the card.
            member_id = if params[:cardnumber].present?
                          BilligTicketCard.where(card: params[:cardnumber]).first.try(:owner_member_id)
                        end

            bp = BilligPurchase.create!(
              owner_member_id: member_id,
              owner_email: params[:email].present? ? params[:email] : nil)

            tickets << BilligTicket.create!(
              ticket: ticket_id,
              on_card: member_id.present?,
              price_group: price_group_id,
              purchase: bp.id
            )
          end
        end
      end

      redirect callback_path << '/' << tickets.map { |ticket| ticket.ticket.to_s << '12345' }.join(',')
    end
  end
end
