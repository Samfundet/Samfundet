puts "Creating crowd funding supporter"

5.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 0,
    amount: rand(100)
  )
end

5.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 1,
    amount: rand(100)
  )
end
puts "Done creating crowd funding supporter"