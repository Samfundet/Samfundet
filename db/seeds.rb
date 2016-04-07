# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Major.create(name: 'Daley', city: cities.first)

require 'declarative_authorization'
require Rails.root.join('lib', 'generate_roles')

raise "Not allowed to seed a production database!" if Rails.env.production?

tables = ActiveRecord::Base.connection.tables
tables.delete("schema_migrations")
puts "Truncating tables #{tables * ", "}."

tables.each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE")
end

# Invoke gem seedscripts
Rake::Task['samfundet_auth_engine:db:seed'].invoke
Authorization.ignore_access_control(true)
Rake::Task['samfundet_domain_engine:db:seed'].invoke

# Create Organizers
puts "Creating external organizers"
ExternalOrganizer.create([
  { name: "Café Nordsør" },
  { name: "NTNU" },
])
puts "Done creating external organizers"

# This is a separate task, using a method in lib/generate_roles.rb
generate_roles

# TOOD: Create extraordinary admission

number_of_applicants = 50
possible_number_of_jobs_in_group = [1, 2, 3]
number_of_job_applications_pr_applicant = 3
admission_title = "Høstopptak 2010"

puts "Creating admission"
admission = Admission.create!(
  title: admission_title,
  shown_from: 1.week.ago,
  shown_application_deadline: 2.weeks.from_now,
  actual_application_deadline: 2.weeks.from_now + 4.hours,
  user_priority_deadline: 3.weeks.from_now,
  admin_priority_deadline: 3.weeks.from_now + 1.hour
)
puts "Done creating admission"

# Create jobs and job descriptions
puts "Creating jobs"
Group.all.each do |group|
  number_of_jobs = possible_number_of_jobs_in_group.sample
  puts number_of_jobs.to_s + " jobs to be created for #{group.short_name}"
  number_of_jobs.times do |n|
    group.jobs.create!(
      admission: admission,
      title_no: Faker::Company.catch_phrase,
      teaser_no: Faker::Lorem.sentence(1),
      description_no: "En fantastisk stilling du bare MÅ søke. " + ("lorem ipsum boller og brus" * 30),
      is_officer: (rand > 0.5)
    )
  end
end
puts "Done with creating jobs"

def distinct_emails(how_many)
  emails = Set.new
  emails << Faker::Internet.email while emails.count < how_many
  emails.to_a
end

def phone_number
  (10000000 + rand * 9000000).to_i.to_s
end

# Create a number of applicants
puts "Creating #{number_of_applicants} applicants, and makes them apply for #{number_of_job_applications_pr_applicant} jobs"
distinct_emails(number_of_applicants).each do |email|
  applicant = Applicant.create!(
    firstname: Faker::Name.first_name,
    surname: Faker::Name.last_name,
    phone: phone_number,
    email: email,
    campus: Faker::Company.name,
    password: 'passord',
    password_confirmation: 'passord'
  )

  # Apply jobs
  puts "New applicant: #{applicant.full_name}"

  jobs = Job.all.sample(number_of_job_applications_pr_applicant)
  jobs.each_with_index do |job, priority|
    JobApplication.create!(
      motivation: Faker::Lorem.paragraphs(5).join("\n\n"),
      applicant: applicant,
      priority: priority + 1,
      job: job
    )
    print "-"
  end
  puts "Done!"
end

puts "Creating samfundet cards for members"
Member.all.each_with_index do |member, index|
  BilligTicketCard.create!(
    card: index * 100,
    owner_member_id: member.id,
    membership_ends: Date.current)
end

# Create images
puts "Creating images"
image_list = ["concert1.jpg", "concert2.jpg", "concert3.jpg", "concert4.jpg", "concert5.jpg"]
image_list.each do |image|
  Image.create!(
      title: image,
      image_file: File.open(Rails.root.join('app', 'assets', 'images', image)),
      uploader: Member.find_by_mail('myrlund@gmail')
    )
  puts "Image #{image} created"
end

# Create default image
Image.create!(
  title: Image::DEFAULT_TITLE,
  image_file: File.open(Image::DEFAULT_PATH))

puts "Done creating images!"


puts "Creating people who have each role in the system"

roles = Role.all
emails = distinct_emails(roles.count)

roles.zip(emails) do |role, email|
  member = Member.create!(
    fornavn: Faker::Name.first_name,
    etternavn: role.title.camelize,
    mail: email,
    telefon: phone_number,
    passord: 'passord',
  )

  puts "New member: #{member.full_name}"

  member.roles << role
end

# Create menu and index pages
puts "Creating pages"
Group.all.each do |group|
  name = group.name.parameterize
  content = "# #{group.name}\n #{Faker::Lorem.paragraphs(3).join("\n\n")}"

  page = Page.create!(
    name_no: name,
    name_en: name,
    title_no: group.name,
    title_en: group.name,
    content_no: content,
    content_en: content,
    role: Role.find_by_title(group.member_role) || Role.super_user
  )

  puts "Created page for: #{group.name.parameterize}"

  group.page = page
  group.save
end

Area.all.each do |area|
  name = area.name.parameterize
  content = "# #{area.name}\n #{Faker::Lorem.paragraphs(3).join("\n\n")}"

  page = Page.create!(
    name_no: name,
    name_en: name,
    title_no: area.name,
    title_en: area.name,
    content_no: content,
    content_en: content,
    role_id: Role.super_user.id
  )

  puts "Created page for area: #{area.name}"

  area.page = page
  area.save
end

puts "Creating ticket pages"
Page.create!(
  name_no: "billetter",
  name_en: Page::TICKETS_NAME,
  title_no: "Billetter",
  title_en: "Tickets",
  content_no: "# Utsalgssteder for billetter\n #{Faker::Lorem.paragraphs(3).join("\n\n")} \n# Salgsbetingelser\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  content_en: "# Purchase areas for tickets\n #{Faker::Lorem.paragraphs(3).join("\n\n")} \n# Purchase conditions\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  role_id: Role.super_user.id
)

puts "Creating information pages"
Page.create!(
  name_no: Page::MENU_NAME,
  name_en: Page::MENU_NAME,
  content_no: "- **Generelt**\n"\
              "\t- **Gjenger**\n#{Group.all.map { |p| "\t\t- [#{p.page.title_no}](/informasjon/#{p.page.name_no})" }.join("\n")}\n"\
              "\t- **Lokaler**\n#{Area.all.map { |p|  "\t\t- [#{p.page.title_no}](/informasjon/#{p.page.name_no})" }.join("\n")}\n",
  content_en: "- **General**\n"\
              "\t- **Groups**\n#{Group.all.map { |p| "\t\t- [#{p.page.title_en}](/informasjon/#{p.page.name_en})" }.join("\n")}\n"\
              "\t- **Areas**\n#{Area.all.map { |p|  "\t\t- [#{p.page.title_en}](/informasjon/#{p.page.name_en})" }.join("\n")}\n",
  role_id: Role.super_user.id
)

puts "Creating about Samfundet pages"
Page.create!(
  name_no: Page::INDEX_NAME,
  name_en: Page::INDEX_NAME,
  content_no: "# Om samfundet\n #{Faker::Lorem.paragraphs(3).join("\n\n")} \n# Historien\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  content_en: "# About samfundet\n #{Faker::Lorem.paragraphs(3).join("\n\n")} \n# The history\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  role_id: Role.super_user.id
)

puts "Creating other information page"
Page.create!(
  name_no: Page::HANDICAP_INFO_NAME,
  name_en: Page::HANDICAP_INFO_NAME,
  content_no: "# Handikap informasjon\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  content_en: "# Handicap information\n #{Faker::Lorem.paragraphs(3).join("\n\n")}",
  role_id: Role.super_user.id
)

puts "Creating markdown help pages"
Page.create!(
  name_no: "markdown",
  name_en: "markdown",
  title_no: "Markdownhjelp",
  title_en: "Markdown help",
  content_no: File.read(Rails.root.join('app', 'assets', '_markdown_no.markdown')),
  content_en: File.read(Rails.root.join('app', 'assets', '_markdown_en.markdown')),
  role_id: Role.super_user.id
)

puts "Done creating pages"

puts "Creating opening hours"
Area.all.each do |area|
  StandardHour::WEEKDAYS.each do |weekday|
    standard_hour = area.standard_hours.build(
      open_time: Time.new(2014, 1, 27, 5 + rand(8), 0, 0),
      close_time: Time.new(2014, 1, 27, 13 + rand(8), 0, 0),
      day: weekday,
      open: [true, false].sample)
    standard_hour.save!
  end

  puts "Created opening hours for #{area.name}"
end
puts "Done creating opening hours"

puts "Creating everything closed periods"
everything_closed_period = EverythingClosedPeriod.new(
  message: "Feiring av sommernissen",
  closed_from: DateTime.current + 2.weeks,
  closed_to: DateTime.current + 3.weeks )
everything_closed_period.save!
puts "Done creating everything closed periods"

# Create area for the whole house
Area.create!(name: 'Hele huset')

# Create events
possible_number_of_events_per_area = [5, 8, 12]
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

puts "Creating events and billig tables"
Area.all.each do |area|
  age_limit = Event::AGE_LIMIT
  event_type = Event::EVENT_TYPE
  status = Event::STATUS
  price_type = Event::PRICE_TYPE

  puts "Creating events for #{area.name}."
  possible_number_of_events_per_area.sample.times do |time|
      event_title = Faker::Lorem.sentence(1)
      start_time =
        (rand 2).weeks.from_now +
        (rand 4).days +
        (rand 5.hours)
      publication_time = 1.weeks.ago + (rand 10).days

      price_t = price_type.sample

      case price_t
      when 'included'
        billig_event = nil
        custom_price_groups = []
      when 'free'
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
          num_sold: rand(number_of_available_tickets+1)
        )
        BilligPriceGroup.create!(
          ticket_group: billig_ticket_group.ticket_group,
          price: 100,
          price_group_name: "Member",
          netsale: true
        )
        BilligPriceGroup.create!(
          ticket_group: billig_ticket_group.ticket_group,
          price: 170,
          price_group_name: "Not member",
          netsale: true
        )
        if rand(2) == 0
          extra_billig_ticket_group = BilligTicketGroup.create!(
            event: billig_event.event,
            num: number_of_available_tickets+100,
          ticket_group_name: 'Girls',
            num_sold: rand(number_of_available_tickets+1)+100
          )
          BilligPriceGroup.create!(
            ticket_group: extra_billig_ticket_group.ticket_group,
            price: 100,
            price_group_name: "Member",
            netsale: true
          )
          BilligPriceGroup.create!(
            ticket_group: extra_billig_ticket_group.ticket_group,
            price: 150,
            price_group_name: "Not member",
            netsale: true
          )
        end
        custom_price_groups = []
      end

      organizer = rand > 0.7 ? Group.order("RANDOM()").first : ExternalOrganizer.order("RANDOM()").first
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
        short_description_en: Faker::Lorem.sentence(12),
        short_description_no: Faker::Lorem.sentence(12),
        long_description_en: Faker::Lorem.sentence(100),
        long_description_no: Faker::Lorem.sentence(100),
        status: status.sample,
        event_type: event_type.sample,
        banner_alignment: banner_alignment.sample,
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
    failed: rand(1.years).ago,
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
  member = Member.order("RANDOM()").first

  on_card = [true, false].sample

  bp = BilligPurchase.create!(
    owner_member_id: on_card ? member.id : nil,
    owner_email: on_card ? nil: member.mail)

  BilligTicket.create!(
    price_group: price_group.price_group,
    purchase: bp.purchase, # Random value, as we don't actually need any purchase objects for local testing.
    on_card: on_card)
end

puts "Creating document categories"
[
  ["Finansstyret", "The financial board"],
  ["Rådet", "The council"],
  ["Styret", "The board"],
  ["Årsberetninger og budsjett", "Yearly reports and budgets"]
].each do |title_no, title_en|
  DocumentCategory.create!(
    title_no: title_no,
    title_en: title_en,
  )
end

puts "Creating blog articles"
Member.all.sample(10).each do |member|
  title = Faker::Lorem.sentence
  image = Image.all.sample

  puts "Creating blog article:  #{title}"
  member.blogs.create!(
    title_no: title,
    title_en: title,
    content_no: Faker::Lorem.sentence(rand(50)) + "![#{image.title}](#{image.image_file(:medium)})" + Faker::Lorem.sentence(rand(20)),
    content_en: Faker::Lorem.sentence(rand(50)) + "![#{image.title}](#{image.image_file(:medium)})" + Faker::Lorem.sentence(rand(20)),
    published: rand > 0.2,
    lead_paragraph_no: Faker::Lorem.sentence(rand(5..10)),
    lead_paragraph_en: Faker::Lorem.sentence(rand(5..10)),
    publish_at: rand(-2..1).weeks.from_now,
    image_id: Image.all.sample.id)
end

#Create sulten reservations
#

type1 = Sulten::ReservationType.create(name: "Drikke", description: "Bord bare for drikke")
type2 = Sulten::ReservationType.create(name: "Mat/drikke", description: "Bord bare for mat og drikke")

table1 = Sulten::Table.create(number: 1, capacity: 8, available: true)
table2 = Sulten::Table.create(number: 2, capacity: 4, available: true)

table1.reservation_types << [type1, type2]
table2.reservation_types << type1

tables = [table1.id, table2.id]
types = [type1.id, type2.id]

15.times.each do
  now = DateTime.now
  date = (now + rand(1..25).days).change(hour: rand(16..20))
  Sulten::Reservation.create(
    name: Faker::Name.first_name,
    people: rand(2..4),
    reservation_from: date,
    email: Faker::Internet.email,
    reservation_duration: 30,
    telephone: phone_number,
    reservation_type_id: types[rand(0..1)],
    table_id: tables[rand(0..1)])
end
