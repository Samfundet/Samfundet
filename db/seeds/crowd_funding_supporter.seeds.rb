puts "Creating crowd funding supporter"

(0..100).step(10) do |i|
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 1,
    amount: rand(1000..10000),
    donors: rand(1..10)
  )
end

(0..100).step(25) do |i|
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 0,
    amount: rand(1000..10000),
    donors: rand(1..10)
  )
end
puts "Done creating crowd funding supporter"