after :images do
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

  puts "Creating documents"
  DocumentCategory.all.each do |category|
    25.times do
        member = Member.order(Arel.sql('random()')).first
        file = File.open(Rails.root.join('app', 'assets', 'files', 'dummy.pdf'))
        publication_date = 2.weeks.ago + (rand 2000).days
        Document.create!(
            title: Faker::Lorem.sentence(word_count: 2),
            category_id: category.id,
            uploader_id: member.id,
            publication_date: publication_date,
            file: file
        )
    end
  end

  puts "Creating blog articles"
  Member.all.sample(10).each do |member|
    title = Faker::Lorem.sentence
    puts "Creating blog article:  #{title}"
    member.blogs.create!(
      title_no: title,
      title_en: title,
      content_no: "# Utsalgssteder for billetter\n#{Faker::Lorem.paragraphs(number: 3).join("\n\n")} \n# Salgsbetingelser\n#{Faker::Lorem.paragraphs(number: 3).join("\n\n")}",
      content_en: "# Purchase areas for tickets\n#{Faker::Lorem.paragraphs(number: 3).join("\n\n")} \n# Purchase conditions\n#{Faker::Lorem.paragraphs(number: 3).join("\n\n")}",
      published: rand > 0.2,
      lead_paragraph_no: Faker::Lorem.sentence(word_count: rand(5..10)),
      lead_paragraph_en: Faker::Lorem.sentence(word_count: rand(5..10)),
      publish_at: rand(-2..1).weeks.from_now,
      image_id: Image.all.sample.id)
  end

  puts "Done creating documents and articles"
end
