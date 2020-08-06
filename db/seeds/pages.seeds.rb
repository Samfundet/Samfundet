after :documents do
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
      role: Role.find_by(title: group.member_role) || Role.super_user
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
                "\t- [Saksdokumenter](/saksdokumenter)\n"\
                "\t- [Åpningstider](/aapningstider)\n"\
                "\t- **Gjenger**\n#{Group.all.map { |p| "\t\t- [#{p.page.title_no}](/informasjon/#{p.page.name_no})" }.join("\n")}\n"\
                "\t- **Lokaler**\n#{Area.all.map { |p|  "\t\t- [#{p.page.title_no}](/informasjon/#{p.page.name_no})" }.join("\n")}\n",
    content_en: "- **General**\n"\
                "\t- [Documents](/dokuments)\n"\
                "\t- [Opening hours](/opening-hours)\n"\
                "\t- **Groups**\n#{Group.all.map { |p| "\t\t- [#{p.page.title_en}](/informasjon/#{p.page.name_en})" }.join("\n")}\n"\
                "\t- **Areas**\n#{Area.all.map { |p|  "\t\t- [#{p.page.title_en}](/informasjon/#{p.page.name_en})" }.join("\n")}\n",
    role_id: Role.super_user.id
  )

  puts "Creating opening hours page"
  Page.create!(
    name_no: "aapningstider",
    name_en: "opening-hours",
    content_no: "# Åpningstider",
    content_en: "# Opening hours",
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
    message_no: "Feiring av sommernissen",
    message_en: "Celebrate the summer santa",
    event_message_no: "For mer informasjon, sjekk ut duvethvem.stream",
    event_message_en: "For more information, check out youknowwho.stream",
    closed_from: DateTime.current + 2.weeks,
    closed_to: DateTime.current + 3.weeks )
  everything_closed_period.save!
  puts "Done creating everything closed periods"

  # Create area for the whole house
  Area.create!(name: 'Hele huset')
end
