namespace :seeds do
  task :demo, [:id] => :environment do |t, args|
    u = Member.find(args[:id])
    u.user_readings.destroy_all
    u.user_readings.create(priority: 50, content: Content.find_by_title('Installed Better'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 49, content: Content.find_by_title('Which of these do you eat?'))
    u.user_readings.create(priority: 48, content: Content.find_by_title('Enter your blood pressure'))
    u.user_readings.create(priority: 47, content: Content.find_by_title('Enter your weight'))
    u.user_readings.create(priority: 46, content: Content.find_by_mayo_doc_id('AN00792'))
    u.user_readings.create(priority: 45, content: Content.find_by_mayo_doc_id('MM00785'))
    u.user_readings.create(priority: 44, content: Content.find_by_mayo_doc_id('NU00284'))
    u.user_readings.create(priority: 43, content: Content.find_by_mayo_doc_id('DS00319'))
    u.user_readings.create(priority: 42, content: Content.find_by_mayo_doc_id('MM00785'))
    u.user_readings.create(priority: 41, content: Content.find_by_mayo_doc_id('HB00087'))
    u.user_readings.create(priority: 40, content: Content.find_by_mayo_doc_id('HI00092'))
    u.user_readings.create(priority: 39, content: Content.find_by_mayo_doc_id('DS00430'))
    u.user_readings.create(priority: 38, content: Content.find_by_mayo_doc_id('MY02383'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 37, content: Content.find_by_mayo_doc_id('HI00021'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 36, content: Content.find_by_mayo_doc_id('MM00767'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 35, content: Content.find_by_mayo_doc_id('MC00013'))
    u.user_readings.create(priority: 34, content: Content.find_by_mayo_doc_id('HI00062'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 33, content: Content.find_by_mayo_doc_id('AN01109'))
    u.user_readings.create(priority: 32, content: Content.find_by_mayo_doc_id('MY02060'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
    u.user_readings.create(priority: 31, content: Content.find_by_mayo_doc_id('AN01805'))
    u.user_readings.create(priority: 30, content: Content.find_by_mayo_doc_id('MY02176'), read_date: Time.zone.now.iso8601, save_date: Time.zone.now.iso8601, save_count: 1)
  end
end
