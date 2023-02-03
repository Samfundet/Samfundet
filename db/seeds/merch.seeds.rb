puts "Create merch"

5.times do
  Product.create!(
    name_no: Faker::GameOfThrones.name,
    name_en: Faker::GameOfThrones.name,
    price: rand(100),
    image_id: 1
  )
end

SIZES = %w[XS S M L XL]

Product.all.each do |product|
  2.times do
    product.product_variations.create!(
      specification: SIZES[rand(SIZES.length)],
      quantity: rand(100)
    )
  end
end
