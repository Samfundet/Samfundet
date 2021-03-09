puts "Creating info box"

COLOR = %w[blue red white green]

3.times do
    InfoBox.create!(
      title_no: Faker::Lorem.sentence(1),
      title_en: Faker::Lorem.sentence(1),
      body_no: "les mer her",
      body_en: "read more here",
      image_id: Image.all.sample.id,
      bg_color: COLOR.sample
    )
end
puts "Done creating info box"
