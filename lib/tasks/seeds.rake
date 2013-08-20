namespace :seeds do
  task :demo => :environment do |t, args|
    %w(mayo@getbetter.com mayo2@getbetter.com mayo3@getbetter.com kyle@getbetter.com geoff@getbetter.com ashlee@getbetter.com dan@getbetter.com paul@getbetter.com tiem@getbetter.com leslie@getbetter.com tara@getbetter.com gavin.enns@xtremelabs.com adrian.kemp@xtremelabs.com).each do |email|
      u = Member.find_or_create_by_email!(email)
      u.update_attributes!(:password => 'mayoclinic',
                           :password_confirmation => 'mayoclinic',
                           :first_name => 'Eric',
                           :last_name => 'Dole',
                           :birth_date => Time.parse('10/3/1965'),
                           :phone => '650-776-7054',
                           :height => 180.34,
                           :diet_id => 6,
                           :blood_type => 'O-',
                           :ethnic_group_id => 6)

      u.encounter_users.destroy_all
      u.messages.destroy_all
      u.message_statuses.destroy_all

      u.user_readings.destroy_all
      u.user_readings.create(priority: 51, content: Content.find_by_title('Welcome to Better!'), read_date: 5.days.ago, save_date: 5.days.ago, save_count: 1)
      u.user_readings.create(priority: 50, content: Content.find_by_title('Which of these do you eat?'))
      u.user_readings.create(priority: 49, content: Content.find_by_title('Enter your blood pressure'))
      u.user_readings.create(priority: 48, content: Content.find_by_title('Enter your weight'))
      u.user_readings.create(priority: 47, content: Content.find_by_mayo_doc_id('AN00792'))
      u.user_readings.create(priority: 46, content: Content.find_by_mayo_doc_id('AZ00009'))
      u.user_readings.create(priority: 45, content: Content.find_by_mayo_doc_id('MM00785'))
      u.user_readings.create(priority: 44, content: Content.find_by_mayo_doc_id('NU00284'))
      u.user_readings.create(priority: 43, content: Content.find_by_mayo_doc_id('DS00319'))
      u.user_readings.create(priority: 42, content: Content.find_by_mayo_doc_id('MM00785'))
      u.user_readings.create(priority: 41, content: Content.find_by_mayo_doc_id('HB00087'))
      u.user_readings.create(priority: 40, content: Content.find_by_mayo_doc_id('AA00045'))
      u.user_readings.create(priority: 39, content: Content.find_by_mayo_doc_id('HI00092'))
      u.user_readings.create(priority: 38, content: Content.find_by_mayo_doc_id('DS00430'))
      u.user_readings.create(priority: 37, content: Content.find_by_mayo_doc_id('MY02383'), read_date: 3.days.ago, save_date: 3.days.ago, save_count: 1)
      u.user_readings.create(priority: 36, content: Content.find_by_mayo_doc_id('HI00021'), read_date: 3.days.ago, save_date: 3.days.ago, save_count: 1)
      u.user_readings.create(priority: 35, content: Content.find_by_mayo_doc_id('MM00767'), read_date: 2.days.ago, save_date: 2.days.ago, save_count: 1)
      u.user_readings.create(priority: 34, content: Content.find_by_mayo_doc_id('MC00013'))
      u.user_readings.create(priority: 33, content: Content.find_by_mayo_doc_id('HI00062'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)
      u.user_readings.create(priority: 32, content: Content.find_by_mayo_doc_id('AN01109'))
      u.user_readings.create(priority: 31, content: Content.find_by_mayo_doc_id('MY02060'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)
      u.user_readings.create(priority: 30, content: Content.find_by_mayo_doc_id('AN01805'))
      u.user_readings.create(priority: 29, content: Content.find_by_mayo_doc_id('MY02176'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)

      u.user_allergies.destroy_all
      u.user_allergies.create(:allergy_id => 60)

      u.weights.destroy_all
      u.weights.create(:amount => 77.56423, :taken_at => Time.parse('11/5/2013'))
      u.weights.create(:amount => 78.92501, :taken_at => Time.parse('20/6/2013'))
      u.weights.create(:amount => 80.73938, :taken_at => Time.parse('2/8/2013'))

      u.blood_pressures.destroy_all
      u.blood_pressures.create(:systolic => 127, :diastolic => 81, :pulse => 60, :collection_type_id => 1, :taken_at => Time.parse('22/3/2013'))
      u.blood_pressures.create(:systolic => 132, :diastolic => 82, :pulse => 65, :collection_type_id => 1, :taken_at => Time.parse('29/4/2013'))
      u.blood_pressures.create(:systolic => 145, :diastolic => 87, :pulse => 70, :collection_type_id => 1, :taken_at => Time.parse('17/6/2013'))
      u.blood_pressures.create(:systolic => 148, :diastolic => 90, :pulse => 70, :collection_type_id => 1, :taken_at => Time.parse('2/8/2013'))

      u.associations.destroy_all

      a = User.create(:first_name => 'Gloria',
                      :last_name => 'Dole',
                      :birth_date => Time.parse('18/9/1968'),
                      :height => 165.1,
                      :diet_id => 5,
                      :blood_type => 'O-',
                      :ethnic_group_id => 6)
      a.blood_pressures.destroy_all
      a.blood_pressures.create(:systolic => 160, :diastolic => 75, :pulse => 68, :collection_type_id => 1, :taken_at => Time.parse('2/8/2013'))
      a.user_allergies.destroy_all
      a.user_allergies.create(:allergy_id => 20)
      a.weights.destroy_all
      a.weights.create(:amount => 58.967, :taken_at => Time.parse('2/8/2013'))

      u.associations.create(:associate => a, :association_type_id => 12)

      m = User.create(:first_name => 'Matt',
                      :last_name => 'Dole',
                      :birth_date => Time.parse('22/4/2000'),
                      :height => 154.94,
                      :diet_id => 1,
                      :blood_type => 'O-',
                      :ethnic_group_id => 6)
      m.blood_pressures.destroy_all
      m.blood_pressures.create(:systolic => 118, :diastolic => 62, :pulse => 65, :collection_type_id => 1, :taken_at => Time.parse('2/8/2013'))
      m.user_allergies.destroy_all
      m.user_allergies.create(:allergy_id => 60)
      m.weights.destroy_all
      m.weights.create(:amount => 47.6272, :taken_at => Time.parse('2/8/2013'))

      u.associations.create(:associate => m, :association_type_id => 8)

      d = User.create(:first_name => 'Paul',
                      :last_name => 'Limburg',
                      :expertise => 'Gastroenterology',
                      :state => 'MN')

      u.associations.create(:associate => d, :association_type_id => 14)
      a.associations.create(:associate => d, :association_type_id => 14)
      m.associations.create(:associate => d, :association_type_id => 14)

      u.user_conditions.destroy_all
      u.user_conditions.create(:disease_id => 1,
                             :start_date => Date.parse('18/6/2013'),
                             :being_treated => true,
                             :diagnosed => true,
                             :diagnoser_id => d.id,
                             :diagnosed_date => Time.parse('20/6/2013'))

      u.user_treatments.destroy_all
      u.user_treatments.create(:treatment_id => 10,
                                       :doctor_id => d.id,
                                       :prescribed_by_doctor => true,
                                       :start_date => Date.parse('22/6/2013'))
    end
  end
end
