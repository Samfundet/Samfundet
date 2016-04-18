namespace :sulten do
  desc "TODO"
  task :generate_days => :environment do
    if not (Sulten::LycheOpeningHours.exists?)
      for x in 1..6
        Sulten::LycheOpeningHours.create(openLyche: "2000-01-01 16:00:00", closeLyche: "2000-01-01 16:00:00", openKitchen: "2000-01-01 16:00:00", closeKitchen: "2000-01-01 16:00:00",day_number: x)
      end
      #Add sunday as last entry
      Sulten::LycheOpeningHours.create(openLyche: "2000-01-01 16:00:00", closeLyche: "2000-01-01 16:00:00", openKitchen: "2000-01-01 16:00:00", closeKitchen: "2000-01-01 16:00:00",day_number: 0)
    end
  end
end
