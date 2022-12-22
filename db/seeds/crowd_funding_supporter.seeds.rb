puts "Creating crowd funding supporter"

5.times do
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 0,
    amount: rand(100)
  )
end

percentages = [0, 25, 50, 75, 100]

percentages.each do |percentage|
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 1,
    amount: percentage
  )
end
puts "Done creating crowd funding supporter"