# -*- encoding : utf-8 -*-

def generate_roles
  Authorization.ignore_access_control true

  Group.all.each do |group|
    group_leader = Role.find_or_create_by_title(
      title: group.group_leader_role.to_s,
      name: "Gjengsjef",
      description: "Rolle for gjengsjef for #{group.name}.",
      group: group
    )

    admission_role = Role.find_or_create_by_title(
      title: group.admission_responsible_role.to_s,
      name: "Opptaksansvarlig",
      description: "Rolle for opptaksperson for #{group.name}.",
      group: group,
      role: group_leader
    )

    event_manager = Role.find_or_create_by_title(
      title: group.event_manager_role.to_s,
      name: "Arrangementansvarlig",
      description: "Rolle for arrangementansvarlig for #{group.name}",
      group: group,
      role: group_leader
    )

    Role.find_or_create_by_title(
      title: group.short_name.parameterize,
      name: group.name,
      description: "Rolle for alle medlemmer av #{group.name}.",
      group: group,
      role: group_leader
    )
  end

  Role.create!(name: "mg_layout", title: "mg_layout", description: "Denne rollen er for medlemmer av mg layout")
  Role.create!(name: "mg_layout_sjef", title: "mg_layout_sjef", description: "Denne rollen er for sjefen av mg layout")
  Role.create!(name: "mg_redaksjon", title: "mg_redaksjon", description: "Denne rollen er for medlemmer av mg redaksjonen")
  Role.create!(name: "ksg_sulten", title: "ksg_sulten", description: "Denne rollen er for medlemmer av ksg for lyches reservasjonssystem")
  Role.create!(name: "mg_nestleder", title: "mg_nestleder", description: "Denne rollen er for nestleder av MG som er opptaksansvarlig for hele huset og dermed har ekstra rettigheter i forbindelse med dette.")
end
