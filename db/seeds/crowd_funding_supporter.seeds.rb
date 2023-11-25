puts "Creating crowd funding supporter"

7.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    name_short: Faker::Lorem.characters(number: 3),
    supporter_type: 1,
    amount: rand(1000..10000),
    donors: rand(1..10)
  )
end

7.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    name_short: Faker::Lorem.characters(number: 3),
    supporter_type: 0,
    amount: rand(1000..10000),
    donors: rand(1..10)
  )
end
puts "Done creating crowd funding supporter"
