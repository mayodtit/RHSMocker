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
                      :expertise => 'Gastroenterology')

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
        state: 'open',
        description: 'I need someone to make an appointment for me.',
        initiator_id: m.id,
        subject_id: m.id,
        messages_attributes: [{
          user: m,
          phone_call_attributes: {
            user: m,
            destination_phone_number: '855-234-5678',
            origin_phone_number: origin_phone_number,
            to_role: PHA_ROLE
          }
        }]
      )

      # Create a call for a Nurse
      c = Consult.create!(
        title: 'Hip hurting',
        state: 'open',
        description: 'My hip hurts really badly.',
        initiator_id: m.id,
        subject_id: m.id,
        messages_attributes: [{
          user: m,
          phone_call_attributes: {
            user: m,
            destination_phone_number: '855-234-5678',
            origin_phone_number: origin_phone_number,
            to_role: NURSE_ROLE
          }
        }]
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

      f.update_attributes attrs
      f.update_attributes! attrs.merge({invitation_token: Time.now.to_i.to_s}) unless f.valid?

      origin_phone_number = nil
      if BOOL_SET.sample
        origin_phone_number = PHONE_NUMBERS.sample
      end

      fc = Consult.create!(
        title: 'Help me prep for my son for his shots',
        state: 'open',
        description: "My son needs to get shots for school. Can you help me?",
        initiator_id: m.id,
        subject_id: f.id,
        messages_attributes: [{
          user: m,
          phone_call_attributes: {
            user: m,
            destination_phone_number: '855-234-5678',
            origin_phone_number: origin_phone_number,
            to_role: PHA_ROLE
          }
        }]
      )

      fc = Consult.create!(
        title: 'Blood in poop',
        state: 'open',
        description: "My relative has blood in their poop.",
        initiator_id: m.id,
        subject_id: f.id,
        messages_attributes: [{
          user: m,
          phone_call_attributes: {
            user: m,
            destination_phone_number: '855-234-5678',
            origin_phone_number: origin_phone_number,
            to_role: NURSE_ROLE
          }
        }]
      )
    end

    TO_INVITE = %w(lauren+nurse@getbetter.com meg+nurse@getbetter.com ninette+nurse@getbetter.com)

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

      m.add_role :nurse unless m.nurse?
    end

    puts 'Creating admins with each inviting a ghost member...'
    %w(paul+admin@getbetter.com abhik+admin@getbetter.com clare+admin@getbetter.com geoff+admin@getbetter.com mark+admin@getbetter.com).each do |email|
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

      m.add_role :admin unless m.admin?

      # Invite the nurses
      TO_INVITE.each do |mail|
        n = Member.find_by_email!(mail)
        m.invitations.create invited_member: n
      end
    end

    puts 'Creating nurses...'
    %w(abhik+nurse@getbetter.com paul+nurse@getbetter.com clare+nurse@getbetter.com mark+nurse@getbetter.com geoff+nurse@getbetter.com).each do |email|
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

      m.add_role :nurse unless m.nurse?
    end

    puts 'Creating PHAs...'
    PHAS = %w(clare+pha@getbetter.com abhik+pha@getbetter.com geoff+pha@getbetter.com paul+pha@getbetter.com mark+pha@getbetter.com)
    PHAS.each do |email|
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

      m.add_role :pha unless m.pha?
    end

    puts 'Creating PHAs leads...'
    PHA_LEADS = %w(clare+lead@getbetter.com abhik+lead@getbetter.com)
    PHA_LEADS.each do |email|
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

      m.add_role :pha_lead unless m.pha_lead?
    end

    puts 'Creating super users...'
    PHA_LEADS = %w(kyle@getbetter.com emilio@getbetter.com neel@getbetter.com)
    PHA_LEADS.each do |email|
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

      m.add_role :pha unless m.pha?
      m.add_role :pha_lead unless m.pha_lead?
      m.add_role :admin unless m.admin?
    end

    puts 'Creating appointments...'
    DAY_OFFSET = [-30.days, -20.days, -10.days, 0.days, 10.days, 20.days, 30.days]
    HOUR_OFFSET = [-2.hours, -1.hours, 0.hours, 1.hours, 2.hours]
    5.times do
      s = ScheduledPhoneCall.create!(
        scheduled_at: Time.now + DAY_OFFSET.sample + HOUR_OFFSET.sample,
      )
    end

    15.times do
      s = ScheduledPhoneCall.new(
        scheduled_at: Time.now + DAY_OFFSET.sample + HOUR_OFFSET.sample,
        owner: Member.find_by_email!(PHAS.sample),
        assignor: Member.find_by_email!(PHA_LEADS.sample),
        assigned_at: Time.now
      )
      s.state = 'assigned'
      s.save!
    end

    5.times do
      m = Member.all.sample
      c = Consult.create!(
        title: 'Welcome Call',
        state: 'open',
        description: "Better welcome call.",
        initiator_id: m.id,
        subject_id: m.id,
        messages_attributes: [{
          user: m,
          scheduled_phone_call_attributes: {
            scheduled_at: Time.now + DAY_OFFSET.sample + HOUR_OFFSET.sample,
            owner: Member.find_by_email!(PHAS.sample),
            assignor: Member.find_by_email!(PHA_LEADS.sample),
            assigned_at: Time.now,
            booker: m,
            user: m,
            callback_phone_number: '4113116969'
          }
        }]
      )

      s = c.messages.first.scheduled_phone_call
      s.booked_at = Time.now
      s.state = 'booked'

      s.save!
    end

  end

  desc "Seed with some member_tasks for PHAs."
  task :member_tasks => :environment do
    40.times do
      m = Member.all.sample
      m.tasks.create!(
        title: 'A member task',
        description: 'Do something for this member',
        service_type: ServiceType.all.sample,
        due_at: Time.now,
        subject: m,
        creator: Member.robot
      )
    end
  end

  desc "Seed with some unresolved calls to PHAs."
  task :calls => :environment do
    PHA_ROLE = Role.find_by_name! :pha
    m = Member.first

    c = Consult.create!(
      title: 'I need an appointment',
      state: 'open',
      description: 'I need someone to make an appointment for me.',
      initiator_id: m.id,
      subject_id: m.id,
      messages_attributes: [{
        user: m,
        phone_call_attributes: {
          user: m,
          destination_phone_number: '8552345678',
          origin_phone_number: '4083913578',
          to_role: PHA_ROLE
        }
      }]
    )
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

  FAKE_MESSAGES = [
    'hi',
    'what\'s up bro?',
    'bro',
    'thanks!',
    'What\'s the best broatmeal recipe?',
    'I could use a Pabst blue ribbon right now',
    'I can\'t help you with that'
  ]
  desc "Adds a specified number of messages to Member's account."
  task :add_messages, [:user_id, :num_messages_to_add] => :environment do |t, args|
    num_messages_to_add = args[:num_messages_to_add].to_i
    puts "Finding member #{args[:user_id]}"
    m = Member.find(args[:user_id])
    if m.master_consult
      puts "Adding #{num_messages_to_add} messages to #{m.full_name}'s master consult"
      num_messages_to_add.times { m.master_consult.messages.create! user: [m,m.pha].sample, text: FAKE_MESSAGES.sample }
    else
      puts "ERROR: #{m.full_name} does not have a master consult"
    end
  end

  desc "add markdown messages to a test account."
  task :add_markdown => :environment do
    markdown_message_one = <<-EOT
Hi Kim, I've found you a few highly rated Primary Care Physicians who are close to home, accepting new patients and take your insurance. Here are the details:

[Dr. Mark B Braunstein](http://doctor.webmd.com/doctor/mark-braunstein-md-b1081742-1e00-4523-abf3-28c6b295ca21-overview)
Address: 4849 Van Nuys Blvd Ste 105, Sherman Oaks ([map](https://www.google.com/maps/search/4849+Van+Nuys+Blvd+Ste+105,+Sherman+Oaks))
Phone: (818) 905-9586
Reviews: [HealthGrades](http://www.healthgrades.com/physician/dr-mark-braunstein-x4lnx), [Vitals](http://www.vitals.com/doctors/Dr_Mark_Braunstein/profile), [Yelp](http://www.yelp.com/biz/mark-braunstein-md-sherman-oaks-2), [Yahoo](https://local.yahoo.com/info-20678324-braunstein-mark-md-braunstein-mark-md-sherman-oaks)
**Next appt: Mid March**

[Dr. Arash D Matian](http://www.primecarela.com/about.html)
Address: 13425 Ventura Blvd Ste 102, Sherman Oaks ([map](https://www.google.com/maps/search/13425+Ventura+Blvd+Ste+102,+Sherman+Oaks))
Phone: (818) 995-7784
Reviews: [HealthGrades](http://www.healthgrades.com/physician/dr-arash-matian-y59jh), [Vitals](http://www.vitals.com/doctors/Dr_Arash_Matian/profile), [Yelp](http://www.yelp.com/biz/prime-care-physicians-sherman-oaks)
**Next appt: Mid March**

[Dr. Gary S Schneider](http://doctor.webmd.com/doctor/gary-schneider-do-d230d6d4-bed0-412d-a1c7-d408f17f6bda-overview)
Address: 4849 Van Nuys Blvd Ste 105, Sherman Oaks ([map](https://www.google.com/maps/search/4849+Van+Nuys+Blvd+Ste+105,+Sherman+Oaks))
Phone: (818) 905-9586
Reviews: [HealthGrades](http://www.healthgrades.com/physician/dr-gary-schneider-36gpg), [Vitals](http://www.vitals.com/doctors/Dr_Gary_Schneider/profile), [Yelp](http://www.yelp.com/biz/schneider-gary-do-inc-sherman-oaks)
**Next appt: Mid April**

Let me know which one looks like a good fit for you and I'll book an appointment!
    EOT

    markdown_message_two = <<-EOT
# H1 heading

1. my list of items that will wrap in the line and use paragraph formatting to keep it all pretty!
1. Another list item
1. Another list item
1. Another list item
1. Another list item
1. Another list item
1. Another list item
1. Another list item
1. Another list item
1. Another list item with another long bunch of stuff that wraps to the next line

## H2 Heading

Here's a link: [Linky](http://www.google.com) <- Link

Italic *here* but the rest of the line should be non italic.
Bold **here**

List follows:
+ First thing that you need to do is make sure of something
+ Second **bold** thing here and itâ€™s got a lot of stuff to say about the list
+ The last thing goes here

My phone: 650-887-3711
    EOT
    m = Member.find_or_create_by_email!(email: 'test+markdown@getbetter.com',
                                        user_agreements_attributes: user_agreements_attributes)
    m.sign_up if m.invited?
    puts 'Member test+markdown@getbetter.com created' if Member.find(m.id)
    message_one = m.master_consult.messages.create! user: m, text: markdown_message_one
    message_two = m.master_consult.messages.create! user: m, text: markdown_message_two
    puts 'test markdown message is created' if Message.find(message_one.id) && Message.find(message_two.id)
  end

  desc "Adds 50 various services to a Member's account"
  task :add_services, [:user_email] => :environment do |t, args|
    m = Member.find_or_create_by_email!(email: args[:user_email] || "test+services@getbetter.com",
                                        password: "password",
                                        user_agreements_attributes: user_agreements_attributes)
    m.sign_up if m.invited?
    if m.pha
      pha = m.pha
    else
      pha = Member.find_or_create_by_email!(email: 'test+pha@getbetter.com',
                                            user_agreements_attributes: user_agreements_attributes)
      pha.add_role :pha
      m.update_attributes(pha: pha)
    end
    if m.services.where(state: 'open').count == 25 && m.services.where(state: 'completed').count == 25
      puts "25 in-progress and 25 completed services are created for user with email: #{m.email}"
      next
    end
    m.services.destroy_all
    service_type = ServiceType.find_or_create_by_name(name: 'member completes goal', bucket: 'wellness')
    25.times do |i|
      m.services.create( title: "open+#{i}", member: m, subject: m, creator: pha, assignor: pha, owner: pha, service_type_id: service_type.id)
      m.services.create( title: "completed+#{i}", member: m, subject: m, creator: pha, owner: pha, assignor: pha, service_type_id: service_type.id).complete!
    end
    puts "25 in-progress and 25 completed services are created for user with email: #{m.email}"
  end

  desc "add b2b onboarding group"
  task :add_b2b_onboarding  => :environment do
    o = OnboardingGroup.find_or_create_by_name(name: "b2b onboarding",
                                               premium: true,
                                               free_trial_days: 0,
                                               skip_credit_card: true,
                                               subscription_days: 90)
    puts "b2b onboarding group is created" if OnboardingGroup.find_by_name("b2b onboarding")
    ReferralCode.find_or_create_by_name(name: 'b2b onboarding',
                                        code: 'b2b_onboarding',
                                        onboarding_group: o)
    puts "b2b onboarding referral code is created" if ReferralCode.find_by_name("b2b onboarding")
  end

  desc "Adds a system message to a Member's account."
  task :add_system_message, [:user_id] => :environment do |t, args|
    puts "Finding member #{args[:user_id]}"
    m = Member.find(args[:user_id])
    if m.master_consult
      m.master_consult.messages.create! user: m.pha, text: 'This is a system message. It should not affect whether an off hours message is sent.', system: true
    else
      puts "ERROR: #{m.full_name} does not have a master consult"
    end
  end

  desc "Fake send a few messages from member accounts"
  task :create_inbound_messages, [:num_messages] => :environment do |t, args|
    num_messages = args[:num_messages]
    puts "Creating #{num_messages} inbound messages"
    members = Member.includes(:master_consult).premium_states.where('consults.id IS NOT NULL').order('RAND()').first(num_messages.to_i)
    members.each do |member|
      member.master_consult.messages.create(user: member, text: FAKE_MESSAGES.sample)
    end
  end

  desc "Adds nurseline summaries for a random member of every PHA in the system."
  task :add_nurseline_summaries, [:unknown] => :environment do |t, args|
    api_user = ApiUser.first || ApiUser.create!(name: 'Test API User')

    NurselineRecord.skip_callback :create, :after, :create_processing_job

    if args[:unknown]
      puts "Adding unknown summary, records, and tasks"

      n = NurselineRecord.create!(
        payload: "<div>Unknown member was coughing up rabbits.</div>",
        api_user: api_user
      )

      ParsedNurselineRecord.create!(
        nurseline_record_id: n.id,
        text: "Unknown member was coughing up rabbits."
      )
    else
      Role.pha.users.each do |pha|
        member = Member.joins(:master_consult).where('NOT status = ?', :free).where(pha_id: pha.id).sample
        next unless member

        puts "PHA #{pha.id} (#{pha.full_name}): Adding summary, records, and tasks to Member #{member.id} (#{member.full_name})"

        n = NurselineRecord.create!(
          payload: "<div>Member #{member.id} was coughing up rabbits.</div>",
          api_user: api_user
        )

        ParsedNurselineRecord.create!(
          user_id: member.id,
          consult_id: member.master_consult.id,
          nurseline_record_id: n.id,
          text: "Member #{member.id} was coughing up rabbits."
        )
      end
    end

    NurselineRecord.set_callback :create, :after, :create_processing_job
  end

  desc "Create a task of every type"
  task :generate_all_task_types, [:pha_email] => :environment do |t, args|
    api_user = ApiUser.first || ApiUser.create!(name: 'Test API User')
    pha_email = args[:pha_email]
    pha = Member.find_by_email(pha_email)

    unless pha && pha.pha?
      puts "Could not find PHA with email #{pha_email}"
      exit()
    end

    puts "Creating a task for every type and assigning to #{pha.full_name}"
    member = Member.includes(:master_consult).premium_states.where('consults.id IS NOT NULL').order('RAND()').first

    # Create a message task and assign it to PHA
    member.master_consult.messages.create(user: member, text: FAKE_MESSAGES.sample)
    member.master_consult.message_tasks.last.update_attributes!(owner_id: pha.id, assignor: Member.robot, actor_id: Member.robot.id)

    # Create a nurseline record task
    n = NurselineRecord.create!(
      payload: "<div>Member #{member.id} was coughing up rabbits.</div>",
      api_user: api_user
    )

    ParsedNurselineRecord.create!(
      user_id: member.id,
      consult_id: member.master_consult.id,
      nurseline_record_id: n.id,
      text: "Member #{member.id} was coughing up rabbits."
    )

    ParsedNurselineRecordTask.last().update_attributes!(owner_id: pha.id, assignor: Member.robot, actor_id: Member.robot.id)

    # Create an upgrade task and assigns it to PHA
    UpgradeTask.create!(member: member, owner: pha, assignor: Member.robot, actor_id: Member.robot.id, title: 'Upgraded', creator: Member.robot, due_at: 1.day.from_now)

    # Create an offboard member task and assign it to PHA
    member.free_trial_ends_at = 4.days.from_now
    OffboardMemberTask.create!(member: member, owner: pha, assignor: Member.robot, actor_id: Member.robot.id, title: 'Offboard', creator: Member.robot, due_at: 1.day.from_now)
  end

  desc "Create a booked welcome call"
  task :create_booked_welcome_call, [:member_email, :pha_email] => :environment do |t, args|
    user = nil
    pha = nil

    user = Member.find_or_create_by_email!(
      email: args[:member_email],
      password: 'careportal',
      user_agreements_attributes: user_agreements_attributes
    )
    user.send :set_master_consult
    pha = Member.find_by_email args[:pha_email]

    prev_global_time_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
    num_days = rand() * 50
    time = Time.roll_forward(num_days.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock
    Time.zone = prev_global_time_zone

    welcome_call = ScheduledPhoneCall.create! scheduled_at: time.utc
    welcome_call.update_attributes!(
      state_event: :assign,
      assignor: Member.robot,
      owner: pha
    )
    welcome_call.update_attributes!(
      state_event: :book,
      booker: user,
      user: user,
      callback_phone_number: "1234567890"
    )
    puts welcome_call.id
  end

  desc "Seed proximity data for US cities"
  task :proximity => :environment do
    s = Roo::Spreadsheet.open(Rails.root.join('lib', 'assets', 'US.xls').to_s)
    puts "Start parsing xls"
    zip = s.column(2)
    city = s.column(3)
    state = s.column(4)
    county = s.column(6)
    latitude = s.column(10)
    longitude = s.column(11)
    puts "Done parsing xls"
    puts "Starting Database population"
    zip.each_with_index { |zipcode, index|
      begin
        Proximity.find_or_create_by_zip_and_city!(zip[index],city[index]) do |loc|
          loc.state = state[index]
          loc.county = county[index]
          loc.latitude = latitude[index]
          loc.longitude = longitude[index]
        end
        print "\r#{index} records processed"
      rescue
        puts "Error adding, ", zipcode
      end
    }
    puts "\nDatabase populated"
  end

  desc "Seed common email domains"
  task :domain => :environment do
    Domain.seed_domains
  end

  def update_allergy(name, code)
    al = Allergy.find_all_by_name(name)
    if al
      if al
        al.each do |a|
          a.snomed_code = code
          a.save
        end
      end
    end
  end
  # Looks at Allergies table and updates entries from db/seeds/allergies.rb by adding description or concept ids
  task :update_allergies_table => :environment do
    require 'open-uri'
    require 'json'
    total = 0
    # fix allergies that require manual fix
    update_allergy('Sulfonamides', '835357010')
    update_allergy('Simvastatin', '690031018')
    update_allergy('Wheat', '2575121014')
    update_allergy('Scorpion Sting', '2645985010')
    update_allergy('Peanut', '835353014')

    al = Allergy.find_by_name('Gluten')
    if al
      al.snomed_code = '2817840017'
      al.snomed_name = 'Gluten sensitivity'
      al.save
    end


    # update allergies using snomed_code
    Allergy.all.each do |al|
      concept_id = al.snomed_code
      base_url = ENV['SNOMED_SEARCH_URL']

      url = base_url + 'concepts/' + concept_id.to_s
      uri = URI.parse(url)
      resp = uri.read

      if resp.include? 'Concept not found'
        desc_id = al.snomed_code
        url = base_url + 'descriptions/' + desc_id.to_s
        uri = URI.parse(url)
        resp = uri.read
        json_resp = JSON.parse(resp)
        if json_resp["matches"][0]
          total += 1
          concept_id = json_resp["matches"][0]["conceptId"]
          term = filter_term(json_resp["matches"][0]["term"])
          puts "#{al.name} ?= #{term.capitalize}"
          al.name = term.capitalize
          store_terms(al, concept_id, desc_id) unless json_resp['matches'].size == 0
        else
          puts "ERROR @ #{desc_id.to_s} = #{al.name}"
        end
      else
        json_resp = JSON.parse(resp)
        match = match_name(al.name, json_resp)
        if match.nil?
          total += 1
          term = filter_term(json_resp['descriptions'][0]['term'])
          puts "#{al.name} ?= #{term.capitalize}"
          al.name = term.capitalize
          store_terms(al, concept_id, json_resp['descriptions'][0]['descriptionId']) 
        else
          store_terms(al, concept_id, match) 
        end
      end
    end
    puts "TOTAL CHANGED: #{total}"

    remove_duplicates('allergies')
  end

  def filter_term(term)
    term = term.downcase
    term.slice!('(disorder)') if term.include? ('(disorder)')
    term.slice!('allergy to ') if term.include? ('allergy to ')
    term.slice!('allergy') if term.include? ('allergy') 
    term = term.strip
    term
  end

  # Finds the description id of an term with by exact match
  def match_name(name, resp)
    resp['descriptions'].each{ |o|
      term = filter_term(o['term'])
      name = name.downcase
      return o['descriptionId'] if term == name.downcase
    }
    return nil
  end

  # Looks at Conditions table and updates entries from db/seeds/conditions.rb by adding description or concept ids
  task :update_conditions_table => :environment do
    require 'open-uri'
    require 'json'
    failed = 0
    base_url = ENV['SNOMED_SEARCH_URL']
    counter = 0

    # manually fix conditions that could not be fixed by the script
    configure_condition('Colitis (Ulcerative)', '64766004', '107644019', 'Ulcerative colitis')
    configure_condition('Depressive Disorder', '35489007', '486184015', 'Depression')
    configure_condition('Gastroesophageal reflux', '235595009', '353135014', 'Gastroesophageal reflux disease')
    configure_condition('Essential Hypertension', '59621000', '99042012', 'Essential hypertension')
    configure_condition('Type 2 Diabetes', '44054006', '197761014', 'Type 2 diabetes mellitus')
    configure_condition('Diabetes', '73211009', '121589010', 'Diabetes mellitus')
    configure_condition('High Cholesterol', '13644009', '475418015', 'Hypercholesterolaemia')
    configure_condition('Overweight', '414916001', '2535065012', 'Obesity')
    configure_condition('Overwieght', '414916001', '2535065012', 'Obesity')
    configure_condition('Underactive Thyroid', '40930008', '492839019', 'Hypothyroid')
    configure_condition('Chronic metabolic disorder', '302866003', '444844011', 'Hypoglycaemia')

    Condition.all.each do |c|
      counter += 1
      print "\r#{counter} "
      desc_id = c.snomed_code.to_s
      url = base_url + 'descriptions/' + desc_id
      uri = URI.parse(url)
      json0 = JSON.parse(uri.read)['matches'][0]

      # check if snomed_code is description id
      if json0 && json0['term'] == c.name
        found = true
        store_terms(c, json0['conceptId'], desc_id)
      else
      # check if snomed_code is concept id
        concept_id = json0 ? json0['conceptId'] : desc_id
        url = base_url + 'concepts/' + concept_id
        uri = URI.parse(url)
        json = JSON.parse(uri.read)
        found = false
        json['descriptions'].each do |concept|
          if concept['term'] == c.name
            store_terms(c, concept_id, concept['descriptionId'].to_s)
            found = true
            break
          end
        end
      end

      # reassign name if id did not match with name in the snomed database
      if !found && json0
        puts "#{desc_id} = #{json0['term']}, original name: #{c.name}" 
        concept_id = json0['conceptId']
        c.name = json0['term']
        store_terms(c, concept_id, desc_id)
        found = true
      end

      if !found
        failed += 1
        puts "Error @ id = #{desc_id}, name = #{c.name}"
      end
    end
    puts "TOTAL FAILED #{failed}"

    # remove the duplicate entries
    remove_duplicates('conditions')
  end

  def configure_condition(oname, cid, did, cname)
    conditions = Condition.find_all_by_name(oname)
    if conditions
      conditions.each do |condition|
        name = condition.name
        condition.name = cname
        condition.description_id = did
        condition.concept_id = cid
        puts "#{condition.description_id} = #{condition.name}, original name: #{name}" 
        condition.save
      end
    end
  end

  # Populates database using SNOMED api, filters out most synonyms
  task :populate_allergies_from_snomed => :environment do
    require 'open-uri'
    base_url = ENV['SNOMED_SEARCH_URL']
    puts "Terms parsed: "
    (0..34).each do |i|
      skip_counter = i * 100

      query = "descriptions?query=allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=#{
      skip_counter}&returnLimit=100&semanticFilter=disorder&normalize=true"
      url = base_url + query
      uri = URI.parse(url)
      resp = uri.read
      matches = JSON.parse(resp)['matches']

      matches.each do |match|
        term = match['term']

        unless term.include? '(disorder)'
          desc_id = match['descriptionId']
          term = filter_term(match['term'])
          term = term.capitalize
          Allergy.find_or_create_by_name(term) do |al|
            name = term.split(' ')
            al.description_id = desc_id
            al.snomed_code = desc_id
            al.concept_id = match['conceptId']
            al.snomed_name = match['fsn']
          end
        end
        print "\r#{skip_counter}"
        skip_counter += 1
      end
    end
  end

  # Updates and saves SNOMED entries that were seeded
  def store_terms(obj, cid, did)
    obj.concept_id = cid
    obj.description_id = did
    obj.save
  end

  def remove_duplicates(type)
    require 'set'
    unique_conditions = {}
    set = Set.new
    type == 'conditions' ? conditions = Condition.all : conditions = Allergy.all

    # first stage: find unique conditions
    conditions.each do |condition|
      desc_id = condition[:description_id]
      if desc_id.nil?  
        puts "ERROR @ #{desc_id} = #{condition[:name]}"
      elsif !set.include?(desc_id)
        set << desc_id          
        unique_conditions[desc_id] = condition[:id]
      end
    end

    # second stage: relink existing users
    duplicate_set = Set.new

    conditions.each do |condition|
      desc_id = condition[:description_id]
      cond_id = condition[:id]
      unique_cond_id = unique_conditions[desc_id]

      if unique_cond_id != cond_id && desc_id != nil
        duplicate_set << cond_id
        type == 'conditions' ? user_conditions = UserCondition.find_all_by_condition_id(cond_id) : user_conditions = UserAllergy.find_all_by_allergy_id(cond_id)

        user_conditions.each do |uc|
          if type == 'conditions'
            uc[:condition_id] = unique_cond_id
            puts "#{uc.id} == #{uc[:condition_id]}"
          else
            uc[:allergy_id] = unique_cond_id
            puts "#{uc.id} == #{uc[:allergy_id]}"
          end
          uc.destroy unless uc.save
        end
      end
    end 
    
    # third stage: delete useless conditions
    duplicate_set.each do |id|
      type == 'conditions' ? Condition.find_by_id(id).destroy : Allergy.find_by_id(id).destroy
      puts "#{id} is removed"
    end
  end
end
