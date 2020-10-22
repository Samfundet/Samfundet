def self.find_available_times(date, duration, people, type_id)
  now = Time.parse(date)
  default_open = now.change(hour: 16, min: 0, sec: 0)
  default_close = now.change(hour: 23, min: 0, sec: 0)
  puts("testtimer")
  puts(default_close-default_open)
  possible_times = []
  time_frame = default_open.to_i..default_close.to_i
  times_to_check = time_frame.step(30.minutes).to_a
  time_frame.step(30.minutes) do |time_step|
    return possible_times if times_to_check.empty?
    next if times_to_check.exclude? time_step
    reservation_from = Time.zone.at(time_step)
    if String(reservation_from).ends_with? "21:30"
      puts(duration)
      duration = duration - 30
      reservation_to = Time.zone.at(time_step + duration.minutes)
      t =self.find_table(reservation_from, reservation_to, people, type_id)
    elsif String(reservation_from).ends_with? "22:00"
      puts(duration)
      duration = duration - 30
      reservation_to = Time.zone.at(time_step + duration.minutes)
      t = self.find_table(reservation_from, reservation_to, people, type_id)
    elsif String(reservation_from).ends_with? "22:30"
      puts("nothing")
    elsif String(reservation_from).ends_with? "23:00"
      puts("nothing")
    else
      reservation_to = Time.zone.at(time_step + duration.minutes)
      t = self.find_table(reservation_from, reservation_to, people, type_id)
    end
    if t
      possible_times.insert(-1, t)
    end
  end
  possible_times
end