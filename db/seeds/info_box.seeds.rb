puts "Creating info box"

InfoBox.create!(
    title_no: "Nybygg er her!",
    title_en: "The new building is here!",
    body_no: "les mer her",
    body_en: "read more here",
    link_no: "https://www.samfundet.no/nybygg",
    link_en: "https://www.samfundet.no/en/nybygg",
    image_id: Image.all.sample.id
    )
puts "Done creating info box"
