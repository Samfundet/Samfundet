puts "Creating crowd funding supporter"

(0..100).step(10) do |i|
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 1,
    amount: i
  )
end

percentages = [0, 25, 50, 75, 100]

percentages.each do |percentage|
  CrowdFundingSupporter.create!(
    name: Faker::Lorem.word(),
    supporter_type: 0,
    amount: percentage
  )
end
puts "Done creating crowd funding supporter"