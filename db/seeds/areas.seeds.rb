puts('Creating areas')

tasks = []

areas = %w(
Storsalen
        Bodegaen
        Klubben
        Strossa
        Selskapssiden
        Knaus
        Edgar
        Lyche
        Daglighallen
        Rundhallen
)

areas.each do |area|
  tasks << Proc.new do
    Area.create! name: area
  end
end

tasks.each_with_index do |task, index|
  task.call
end
