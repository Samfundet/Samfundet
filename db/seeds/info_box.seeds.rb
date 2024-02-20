puts "Creating info box"

COLOR = %w[blue red white green black]

2.times do
    InfoBox.create!(
      title_no: Faker::Lorem.sentence,
      title_en: Faker::Lorem.sentence,
      body_no: "les mer her",
      body_en: "read more here",
      image_id: Image.all.sample.id,
      image_state: true,
      color: COLOR.sample,
      start_time:Time.current,
      end_time: (rand 2).weeks.from_now +
        (rand 4).days +
        (rand 5.hours.to_i),
      position: rand(10)
    )
end

InfoBox.create!(
  title_no: Faker::Lorem.sentence,
  title_en: Faker::Lorem.sentence,
  body_no: "les mer her",
  body_en: "read more here",
  image_id: Image.all.sample.id,
  image_state: false,
  color: COLOR.sample,
  start_time:Time.current,
  end_time: (rand 2).weeks.from_now +
    (rand 4).days +
    (rand 5.hours.to_i),
  position: 1

)
puts "Done creating info box"
