desc "Backfill BMI."
task :backfill_bmi => :environment do
  Weight.where(bmi: nil).each{|w| w.save!}
end
