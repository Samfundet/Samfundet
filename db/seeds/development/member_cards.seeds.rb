puts "Creating samfundet cards for members"
Member.all.each_with_index do |member, index|
  BilligTicketCard.create!(
    card: index * 100,
    owner_member_id: member.id,
    membership_ends: Date.current)
end