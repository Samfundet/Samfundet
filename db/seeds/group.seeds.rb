after :areas do
  tasks = []

  puts('Creating groups')

  [GroupType, Group, Area].each do |model|
    tasks << Proc.new do
      model.delete_all
    end
  end

  group_types = %w(
        Styrende\ organ
        Arrangerende
        Drift
        Kunstneriske
        Media
        Festivaler
        Administrative
        Andre\ grupperinger
  )

  group_types.each_with_index do |group_type, priority|
    tasks << Proc.new do
      GroupType.create!(
        description: group_type,
        priority: priority
      )
    end
  end

  groups = [
    { name: 'Arkivet', abbreviation: '', group_type: 'Administrative' },
    { name: 'Regi', abbreviation: '', group_type: 'Drift' },
    { name: 'ISFiT 2011', abbreviation: '', group_type: 'Festivaler' },
    { name: 'Samfundets byggekomite', abbreviation: 'SBK', group_type: 'Administrative' },
    { name: 'Finansstyret', abbreviation: 'FS', group_type: 'Styrende organ' },
    { name: 'Propheten', abbreviation: '', group_type: 'Media' },
    { name: 'Kulturutvalget', abbreviation: 'KU', group_type: 'Arrangerende' },
    { name: 'IT-komiteen', abbreviation: 'ITK', group_type: 'Drift' },
    { name: 'Kontrollkontoret', abbreviation: 'KK', group_type: 'Drift' },
    { name: 'Radio Revolt', abbreviation: 'Radion', group_type: 'Media' },
    { name: "Big Mama's Cowboys", abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'S. Møller Storband', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Lørdagskomitéen', abbreviation: 'LK', group_type: 'Arrangerende' },
    { name: 'Profilgruppa', abbreviation: 'Profil', group_type: 'Drift' },
    { name: 'Markedsføringsgjengen', abbreviation: 'MG', group_type: 'Drift' },
    { name: 'Musikerlåfte', abbreviation: 'Låfte', group_type: 'Kunstneriske' },
    { name: 'Diversegjengen', abbreviation: 'DG', group_type: 'Drift' },
    { name: 'Videokomitéen', abbreviation: 'VK', group_type: 'Drift' },
    { name: 'Trondhjems Kvinnelige Studentersangforening', abbreviation: 'TKS', group_type: 'Kunstneriske' },
    { name: 'Rådet', abbreviation: '', group_type: 'Styrende organ' },
    { name: 'Strindens Prom Orchester', abbreviation: 'SPO', group_type: 'Kunstneriske' },
    { name: 'Kjellerbandet', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Leisure Suit Lovers', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Pirum', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Snaustrinda', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Symfoniorkesteret', abbreviation: 'Symforch', group_type: 'Kunstneriske' },
    { name: 'Salongorkestret', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Knauskoret', abbreviation: '', group_type: 'Kunstneriske' },
    { name: 'Trondheim InterRail Centre', abbreviation: 'TIRC', group_type: 'Andre grupperinger' },
    { name: 'Gjengsekretariatet', abbreviation: 'GS', group_type: 'Administrative' },
    { name: 'Akademisk Radioklubb', abbreviation: 'ARK', group_type: 'Drift' },
    { name: 'Under Dusken', abbreviation: 'UD', group_type: 'Media' },
    { name: 'UKA-11', abbreviation: '', group_type: 'Festivaler' },
    { name: 'Sitting ducks', abbreviation: 'SD', group_type: 'Kunstneriske' },
    { name: 'Trondhjems Studentersangforening', abbreviation: 'TSS', group_type: 'Kunstneriske' },
    { name: 'Student-TV', abbreviation: 'STV', group_type: 'Media' },
    { name: 'Kafé- og Serveringsgjengen', abbreviation: 'KSG', group_type: 'Arrangerende' },
    { name: 'Klubbstyret', abbreviation: 'KLST', group_type: 'Arrangerende' },
    { name: 'Studentersamfundets Interne Teater', abbreviation: 'SIT', group_type: 'Kunstneriske' },
    { name: 'Styret', abbreviation: '', group_type: 'Styrende organ' },
    { name: 'Gjengsjefkollegiet', abbreviation: 'GSK', group_type: 'Administrative' },
    { name: 'Forsterkerkomiteen', abbreviation: 'FK', group_type: 'Drift' },
    { name: 'Fotogjengen', abbreviation: 'FG', group_type: 'Drift' },
    { name: 'Candiss', abbreviation: '', group_type: 'Kunstneriske' },
  ]

  groups.each do |group|
    tasks << Proc.new do
      Group.create!(
        name: group[:name],
        abbreviation: group[:abbreviation],
        group_type: GroupType.find_by_description(group[:group_type])
      )
    end
  end

  tasks.each_with_index do |task, index|
    task.call
  end
end
