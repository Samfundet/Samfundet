puts "Create Merch"

puts "Create Product with Variation"
  Product.create!(
    name_no: "Tshirt",
    name_en: "Tshirt",
    price: 100,
    image_id: Image.where(title: "seed/tshirt.png").sample.id,
    release_time: Time.now
  )

SIZES = %w[XS S M L XL]
puts "create Product variations"
Product.limit(2).each do |product|
  2.times do
    product.product_variations.create!(
      name: SIZES[rand(SIZES.length)],
      amount: rand(100)
    )
  end
end

puts "Create Product without Variation"
Product.create!(
  name_no: "Mug",
  name_en: "Mug",
  price: 50,
  image_id: Image.where(title: "seed/mug.jpg").sample.id,
  has_variations: false,
  amount: rand(100),
  release_time: Time.now
)

puts "Create Orders"

2.times do
  Order.create!(
    email: Faker::Internet.email,
    name: Faker::Name.name
  )
end

Order.all.each do |order|
  order.order_products.create!(
    amount: rand(1..5),
    product_id: Product.where(has_variations: false).sample.id
    )
  order.order_products.create!(
    amount: rand(1..5),
    product_variation_id: ProductVariation.all.sample.id
  )
end