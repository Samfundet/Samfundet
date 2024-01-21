puts "Generating roles"
Group.all.each do |group|
  group_leader = Role.create_with(
    name: 'Gjengsjef',
    description: "Rolle for gjengsjef for #{group.name}.",
    group: group
  ).find_or_create_by(
    title: group.group_leader_role.to_s
  )

  admission_role = Role.create_with(
    name: 'Opptaksansvarlig',
    description: "Rolle for opptaksperson for #{group.name}.",
    group: group,
    role: group_leader
  ).find_or_create_by(
    title: group.admission_responsible_role.to_s
  )

  event_manager = Role.create_with(
    name: 'Arrangementansvarlig',
    description: "Rolle for arrangementansvarlig for #{group.name}",
    group: group,
    role: group_leader
  ).find_or_create_by(
    title: group.event_manager_role.to_s
  )

  Role.create_with(
    name: group.name,
    description: "Rolle for alle medlemmer av #{group.name}.",
    group: group,
    role: group_leader
  ).find_or_create_by(
    title: group.short_name.parameterize
  )
end

Role.create!(name: 'mg_layout', title: 'mg_layout', description: 'Denne rollen er for medlemmer av mg layout')
Role.create!(name: 'mg_layout_sjef', title: 'mg_layout_sjef', description: 'Denne rollen er for sjefen av mg layout')
Role.create!(name: 'mg_redaksjon', title: 'mg_redaksjon', description: 'Denne rollen er for medlemmer av mg redaksjonen')
Role.create!(name: 'ksg_sulten', title: 'ksg_sulten', description: 'Denne rollen er for medlemmer av ksg for lyches reservasjonssystem')
Role.create!(name: 'gu_nestleder', title: 'gu_nestleder', description: 'Denne rollen er for nestleder av GU som er opptaksansvarlig for hele huset og dermed har ekstra rettigheter i forbindelse med dette.')
puts "Done generating roles."
