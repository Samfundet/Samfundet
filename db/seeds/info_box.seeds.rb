puts "Creating info box"

3.times do
    InfoBox.create!(
      title_no: Faker::Lorem.sentence(1),
      title_en: Faker::Lorem.sentence(1),
      body_no: "les mer her",
      body_en: "read more here",
      image_id: Image.all.sample.id
    )
end
puts "Done creating info box"
