puts "Create Merch"

puts "Create Product"
5.times do
  Product.create!(
    name_no: Faker::GameOfThrones.character,
    name_en: Faker::GameOfThrones.character,
    price: rand(100),
    image_id: 1
  )
end

SIZES = %w[XS S M L XL]
puts "create Product variations"
Product.all.each do |product|
  2.times do
    product.product_variations.create!(
      specification: SIZES[rand(SIZES.length)],
      quantity: rand(100)
    )
  end
end
