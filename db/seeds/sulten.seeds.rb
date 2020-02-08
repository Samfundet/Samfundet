#Create sulten reservations
puts "Creating lyche reservations"

type1 = Sulten::ReservationType.create(name: "Drikke", description: "Bord bare for drikke")
type2 = Sulten::ReservationType.create(name: "Mat/drikke", description: "Bord bare for mat og drikke")

table1 = Sulten::Table.create(number: 1, capacity: 8, available: true)
table2 = Sulten::Table.create(number: 2, capacity: 4, available: true)
table3 = Sulten::Table.create(number: 35, capacity: 18, available: true)

table1.reservation_types << [type1, type2]
table2.reservation_types << type1
table3.reservation_types << [type1, type2]

tables = [table1.id, table2.id, table3.id]
types = [type1.id, type2.id]

# Initialize list of tables
30.times.each do
  now = DateTime.now
  date = (now + rand(1..25).days).change(hour: rand(16..20))
  Sulten::Reservation.create(
    name: Faker::Name.first_name,
    people: rand(2..4),
    reservation_from: date,
    email: Faker::Internet.email,
    reservation_duration: 30,
    telephone: Faker::PhoneNumber.cell_phone,
    reservation_type_id: types[rand(0..1)],
    table_id: tables[rand(0..1)],
    allergies: rand(0..3) == 0 ? Faker::Lorem.sentence : nil
  )
end