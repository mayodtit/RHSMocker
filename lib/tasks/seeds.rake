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

      u.messages.destroy_all
      u.message_statuses.destroy_all

      u.user_readings.destroy_all
      u.user_readings.create(priority: 51, content: Content.find_by_title('Welcome to Better!'), read_date: 5.days.ago, save_date: 5.days.ago, save_count: 1)
      u.user_readings.create(priority: 50, content: Content.find_by_title('Which of these do you eat?'))
      u.user_readings.create(priority: 49, content: Content.find_by_title('Enter your blood pressure'))
      u.user_readings.create(priority: 48, content: Content.find_by_title('Enter your weight'))
      u.user_readings.create(priority: 47, content: Content.find_by_document_id('AN00792'))
      u.user_readings.create(priority: 46, content: Content.find_by_document_id('AZ00009'))
      u.user_readings.create(priority: 45, content: Content.find_by_document_id('MM00785'))
      u.user_readings.create(priority: 44, content: Content.find_by_document_id('NU00284'))
      u.user_readings.create(priority: 43, content: Content.find_by_document_id('DS00319'))
      u.user_readings.create(priority: 42, content: Content.find_by_document_id('MM00785'))
      u.user_readings.create(priority: 41, content: Content.find_by_document_id('HB00087'))
      u.user_readings.create(priority: 40, content: Content.find_by_document_id('AA00045'))
      u.user_readings.create(priority: 39, content: Content.find_by_document_id('HI00092'))
      u.user_readings.create(priority: 38, content: Content.find_by_document_id('DS00430'))
      u.user_readings.create(priority: 37, content: Content.find_by_document_id('MY02383'), read_date: 3.days.ago, save_date: 3.days.ago, save_count: 1)
      u.user_readings.create(priority: 36, content: Content.find_by_document_id('HI00021'), read_date: 3.days.ago, save_date: 3.days.ago, save_count: 1)
      u.user_readings.create(priority: 35, content: Content.find_by_document_id('MM00767'), read_date: 2.days.ago, save_date: 2.days.ago, save_count: 1)
      u.user_readings.create(priority: 34, content: Content.find_by_document_id('MC00013'))
      u.user_readings.create(priority: 33, content: Content.find_by_document_id('HI00062'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)
      u.user_readings.create(priority: 32, content: Content.find_by_document_id('AN01109'))
      u.user_readings.create(priority: 31, content: Content.find_by_document_id('MY02060'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)
      u.user_readings.create(priority: 30, content: Content.find_by_document_id('AN01805'))
      u.user_readings.create(priority: 29, content: Content.find_by_document_id('MY02176'), read_date: 1.day.ago, save_date: 1.day.ago, save_count: 1)

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
      u.user_conditions.create(:condition_id => 1,
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

  desc "Seed the database for Care Portal testing on all roles (e.g. admin, nurse, pha)."
  task :care => :environment do
    BOOL_SET = [true, true, false]
    LAST_NAMES = ['Smith', 'Henry', 'Johnson', 'Patel', 'Chen', 'Nightingale', 'Richards', 'Shah', 'Singh', 'Rivera', 'Lin']
    GENDERS = ['male', 'female']
    PHONE_NUMBERS = ['408-555-1212', '415-555-0100', '510-555-7236']
    NURSE_ROLE = Role.find_by_name! :nurse
    PHA_ROLE = Role.find_by_name! :pha

    def time_rand from = Time.parse('1/1/1930'), to = Time.parse('1/1/1995')
      Time.at(from + rand * (to.to_f - from.to_f))
    end

    puts 'Creating members along with a phone call for nurse and pha...'
    %w(joey@example.com suzy@example.com geoff@example.com jackie@example.com peter@example.com tarsem@example.com ruchi@example.com).each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      attrs = {
        password: 'careportal',
        password_confirmation: 'careportal'
      }

      if BOOL_SET.sample
        attrs[:first_name] = email[/[^@]+/].capitalize
      else
        attrs[:first_name] = nil
      end

      if BOOL_SET.sample
        attrs[:last_name] = LAST_NAMES.sample
      else
        attrs[:last_name] = nil
      end

      if BOOL_SET.sample
        attrs[:birth_date] = time_rand
      else
        attrs[:birth_date] = nil
      end

      if BOOL_SET.sample
        attrs[:gender] = GENDERS.sample
      else
        attrs[:gender] = nil
      end

      m.update_attributes! attrs

      origin_phone_number = nil
      if BOOL_SET.sample
        origin_phone_number = PHONE_NUMBERS.sample
      end

      # Create a call for a PHA
      c = Consult.create!(
        title: 'I need an appointment',
        status: 'open',
        priority: 'low',
        description: 'I need someone to make an appointment for me.',
        initiator_id: m.id,
        subject_id: m.id,
        add_user: m,
        phone_call: {
          message: nil,
          destination_phone_number: '855-234-5678',
          origin_phone_number: origin_phone_number,
          to_role: PHA_ROLE
        }
      )

      # Create a call for a Nurse
      c = Consult.create!(
        title: 'Hip hurting',
        status: 'open',
        priority: 'low',
        description: 'My hip hurts really badly.',
        initiator_id: m.id,
        subject_id: m.id,
        add_user: m,
        phone_call: {
          message: nil,
          destination_phone_number: '855-234-5678',
          origin_phone_number: origin_phone_number,
          to_role: NURSE_ROLE
        }
      )
    end

    puts 'Creating members, a family member, and a call about that family member for nurse and pha...'
    %w(polly@example.com crissy@example.com samantha@example.com clementine@example.com).each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      attrs = {
        password: 'careportal',
        password_confirmation: 'careportal'
      }

      if BOOL_SET.sample
        attrs[:first_name] = email[/[^@]+/].capitalize
      else
        attrs[:first_name] = nil
      end

      if BOOL_SET.sample
        attrs[:last_name] = LAST_NAMES.sample
      else
        attrs[:last_name] = nil
      end

      if BOOL_SET.sample
        attrs[:birth_date] = time_rand
      else
        attrs[:birth_date] = nil
      end

      if BOOL_SET.sample
        attrs[:gender] = GENDERS.sample
      else
        attrs[:gender] = nil
      end

      m.update_attributes! attrs

      # Create a family member and a consult for the family member
      family_email = "relative_of_#{email}"
      f = Member.find_or_create_by_email!(email: family_email)

      # TODO: Actually create the relationship

      attrs = {}

      if BOOL_SET.sample
        attrs[:first_name] = email[/[^@]+/].capitalize
      else
        attrs[:first_name] = nil
      end

      if BOOL_SET.sample
        attrs[:last_name] = LAST_NAMES.sample
      else
        attrs[:last_name] = nil
      end

      if BOOL_SET.sample
        attrs[:birth_date] = time_rand
      else
        attrs[:birth_date] = nil
      end

      if BOOL_SET.sample
        attrs[:gender] = GENDERS.sample
      end

      f.update_attributes! attrs

      origin_phone_number = nil
      if BOOL_SET.sample
        origin_phone_number = PHONE_NUMBERS.sample
      end

      fc = Consult.create!(
        title: 'Help me prep for my son for his shots',
        status: 'open',
        priority: 'high',
        description: "My son needs to get shots for school. Can you help me?",
        initiator_id: m.id,
        subject_id: f.id,
        add_user: m,
        phone_call: {
          message: nil,
          destination_phone_number: '855-234-5678',
          origin_phone_number: origin_phone_number,
          to_role: PHA_ROLE
        }
      )

      fc = Consult.create!(
        title: 'Blood in poop',
        status: 'open',
        priority: 'high',
        description: "My relative has blood in their poop.",
        initiator_id: m.id,
        subject_id: f.id,
        add_user: m,
        phone_call: {
          message: nil,
          destination_phone_number: '855-234-5678',
          origin_phone_number: origin_phone_number,
          to_role: NURSE_ROLE
        }
      )
    end

    TO_INVITE = %w(clarissa@mayo.example.com matt@mayo.example.com)

    puts 'Creating ghost members to invite as nurses...'
    TO_INVITE.each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      m.update_attributes!(
        first_name: email[/[^@]+/].capitalize,
        last_name: LAST_NAMES.sample,
      )

      m.add_role :nurse
    end

    puts 'Creating admins with each inviting a ghost member...'
    %w(paul@admin.getbetter.com abhik@admin.getbetter.com clare@admin.getbetter.com geoff@admin.getbetter.com mark@admin.getbetter.com).each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      m.update_attributes!(
        password: 'careportal',
        password_confirmation: 'careportal',
        first_name: email[/[^@]+/].capitalize,
        last_name: LAST_NAMES.sample,
      )

      m.add_role :admin

      # Invite the nurses
      TO_INVITE.each do |mail|
        n = Member.find_by_email!(mail)
        m.invitations.create invited_member: n
      end
    end

    puts 'Creating nurses...'
    %w(florence@mayo.example.com mary@mayo.example.com walt@mayo.example.com clarissa@mayo.example.com).each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      m.update_attributes!(
        password: 'careportal',
        password_confirmation: 'careportal',
        first_name: email[/[^@]+/].capitalize,
        last_name: LAST_NAMES.sample,
      )

      m.add_role :nurse
    end

    puts 'Creating PHAs...'
    %w(clare@pha.getbetter.com abhik@pha.getbetter.com geoff@pha.getbetter.com paul@pha.getbetter.com mark@pha.getbetter.com).each do |email|
      m = Member.find_or_create_by_email!(
        email: email,
        user_agreements_attributes: user_agreements_attributes
      )

      m.update_attributes!(
        password: 'careportal',
        password_confirmation: 'careportal',
        first_name: email[/[^@]+/].capitalize,
        last_name: LAST_NAMES.sample,
      )

      m.add_role :pha
    end
  end

  def user_agreements_attributes
    return [] unless Agreement.active
    [
      {
        agreement_id: Agreement.active.id,
        user_agent: 'seeds',
        ip_address: 'seeds'
      }
    ]
  end
end
