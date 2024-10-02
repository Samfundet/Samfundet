puts "Creating events and billig tables"

possible_number_of_events_per_area = [8, 10, 15]
possible_payment_errors = [
"Vennligst fyll inn antall billetter.",
"Arrangementet er utsolgt, eller har for få billetter igjen til å tilfredsstille ordren din.",
"Du avbrøt operasjonen, og ingen penger er derfor trukket. (Feilreferanse 18997)",
"Ugyldig utløpsdato.",
"Du må skrive inn én av epostadresse eller kortnummer.",
"Kortet du oppga er ikke et gyldig, aktivt, registrert medlemskort. Registrer kort eller nytt oblat på medlem.samfundet.no, eller bruk en epostadresse i stedet.",
"Betalingsinformasjonen manglet eller var ufullstendig.",
"Fikk ikke trukket penger fra kontoen. Sjekk at det finnes penger på konto samt at utløpsdato og CVC2 er riktig, og prøv igjen. (Feilreferanse 18972)",
"Ugyldig CVC2-kode. CVC2-koden er på tre siffer, og finnes i signaturfeltet bak på kortet ditt."
]

age_limit = Event::AGE_LIMIT
event_type = Event::EVENT_TYPE
status = Event::STATUS
colors = %w(#000 #2c3e50 #f1c40f #7f8c8d #9b59b6 #8e44ad)
banner_alignment = Event::BANNER_ALIGNMENT
puts "Creating custom price groups"
price_group_names = ["Medlem", "Ikke-medlem"]

price_group_names.each do |group|
  (60..190).step(10) do |price|
    PriceGroup.create(name: group, price: price)
  end
end
Area.all.each do |area|
  age_limit = Event::AGE_LIMIT
  event_type = Event::EVENT_TYPE
  status = Event::STATUS
  price_type = Event::PRICE_TYPE

  puts "Creating events for #{area.name}."
  possible_number_of_events_per_area.sample.times do |time|
      event_title = Faker::Lorem.sentence
      start_time =
        (rand 2).weeks.from_now +
        (rand 4).days +
        (rand 5.hours.to_i)
      publication_time = 1.weeks.ago + (rand 10).days

      price_t = price_type.sample

      case price_t
      when 'included'
        billig_event = nil
        custom_price_groups = []
      when 'free'
        billig_event = nil
        custom_price_groups = []
      when 'free_registration'
        billig_event = nil
        custom_price_groups = []
      when 'custom'
        billig_event = nil
        custom_price_groups = PriceGroup.all.sample(2)
      when 'billig'
        billig_event = BilligEvent.create!(
          event_name: "Billig #{event_title}",
          event_time: start_time,
          sale_from: DateTime.current,
          sale_to: start_time + 4.hours,
          event_location: "billig-#{area.name}",
          hidden: false
        )
        number_of_available_tickets = rand(3) + 1
        billig_ticket_group = BilligTicketGroup.create!(
          event: billig_event.event,
          num: number_of_available_tickets,
          ticket_group_name: 'Boys',
          num_sold: rand(number_of_available_tickets+1),
          ticket_limit: rand(10) < 5 ? nil : rand(1..10)
        )
        BilligPriceGroup.create!(
          ticket_group: billig_ticket_group.ticket_group,
          price: 100,
          price_group_name: "Member",
          netsale: true,
          membership_needed: true
        )
        if rand(2) == 0
          BilligPriceGroup.create!(
            ticket_group: billig_ticket_group.ticket_group,
            price: 170,
            price_group_name: "Not member",
            netsale: true,
            membership_needed: false
          )
        end
        if rand(2) == 0
          extra_billig_ticket_group = BilligTicketGroup.create!(
            event: billig_event.event,
            num: number_of_available_tickets+100,
            ticket_group_name: 'Girls',
            num_sold: rand(number_of_available_tickets+1)+100,
            ticket_limit: rand(10) < 5 ? nil : rand(1..10)
          )
          BilligPriceGroup.create!(
            ticket_group: extra_billig_ticket_group.ticket_group,
            price: 100,
            price_group_name: "Member",
            netsale: true,
            membership_needed: true
          )
          BilligPriceGroup.create!(
            ticket_group: extra_billig_ticket_group.ticket_group,
            price: 150,
            price_group_name: "Not member",
            netsale: true,
            membership_needed: false
          )
        end
        custom_price_groups = []
      end

      organizer = rand > 0.7 ? Group.order(Arel.sql('random()')).first : ExternalOrganizer.order(Arel.sql('random()')).first
      chosen_colors = colors.sample(2)

      Event.create!(
        area_id: area.id,
        organizer_id: organizer.id,
        organizer_type: organizer.class.name,
        title_en: event_title,
        non_billig_title_no: event_title,
        publication_time: publication_time,
        non_billig_start_time: start_time,
        age_limit: age_limit.sample,
        short_description_en: Faker::Lorem.sentence(word_count: 12),
        short_description_no: Faker::Lorem.sentence(word_count: 12),
        long_description_en: Faker::Lorem.sentence(word_count: 100),
        long_description_no: Faker::Lorem.sentence(word_count: 100),
        status: status.sample,
        event_type: event_type.sample,
        banner_alignment: "hide", #banner_alignment.sample,
        spotify_uri: "spotify:user:alericm:playlist:3MI1e3OWArXKFKfPQ4MXXh",
        primary_color: chosen_colors.first,
        secondary_color: chosen_colors.last,
        billig_event_id: billig_event.try(:event),
        price_groups: custom_price_groups,
        image_id: Image.all.sample.id,
        facebook_link: "https://www.facebook.com/events/479745162154320",
        youtube_link: "http://www.youtube.com/watch?v=dQw4w9WgXcQ",
        vimeo_link: "http://vimeo.com/23583043",
        general_link: "http://nightwish.com/",
        price_type: price_t
      )
      print "-"
  end
  puts "Done!"
end

puts "Creating billig payment errors and price groups"
possible_payment_errors.each do |error_message|
  bsession = SecureRandom.uuid
  on_card = rand > 0.5

  BilligPaymentError.create!(
    error: bsession,
    failed: rand(1.years.to_i).second.ago,
    owner_cardno: on_card ? rand(10000..999999) : nil,
    owner_email: on_card ? nil : Faker::Internet.email,
    message: error_message
  )

  BilligPaymentErrorPriceGroup.create!(
    error: bsession,
    price_group: BilligPriceGroup.all.sample.price_group,
    number_of_tickets: rand(1..10)
  )
end

puts "Creating successfull purchases"
BilligPriceGroup.all.each do |price_group|
  member = Member.order(Arel.sql('random()')).first

  on_card = [true, false].sample

  bp = BilligPurchase.create!(
    owner_member_id: on_card ? member.id : nil,
    owner_email: on_card ? nil: member.mail)

  BilligTicket.create!(
    price_group: price_group.price_group,
    purchase: bp.purchase, # Random value, as we don't actually need any purchase objects for local testing.
    on_card: on_card)
end
