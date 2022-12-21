puts "Creating crowd funding supporter"

5.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.sentence(1),
    supporter_type: rand(2),
    amount: rand(100)
  )
end

puts "Done creating crowd funding supporter"