puts "Create Merch"

puts "Create Product with Variation"
2.times do
  Product.create!(
    name_no: Faker::GameOfThrones.character,
    name_en: Faker::GameOfThrones.character,
    price: rand(100),
    image_id: Image.offset(1).limit(1).sample.id
  )
end

SIZES = %w[XS S M L XL]
puts "create Product variations"
Product.limit(2).each do |product|
  2.times do
    product.product_variations.create!(
      specification: SIZES[rand(SIZES.length)],
      quantity: rand(100)
    )
  end
end

puts "Create Product without Variation"
2.times do
  Product.create!(
    name_no: Faker::GameOfThrones.character,
    name_en: Faker::GameOfThrones.character,
    price: rand(100),
    image_id: Image.offset(1).limit(1).sample.id,
    has_variations: false,
    amount: rand(100)
  )
end
