puts "Creating info box"

COLOR = %w[blue red white green black]

3.times do
    InfoBox.create!(
      title_no: Faker::Lorem.sentence(1),
      title_en: Faker::Lorem.sentence(1),
      body_no: "les mer her",
      body_en: "read more here",
      image_id: Image.all.sample.id,
      color: COLOR.sample,
      start_time:Time.current,
      end_time: (rand 2).weeks.from_now +
        (rand 4).days +
        (rand 5.hours.to_i)

    )
end
puts "Done creating info box"
