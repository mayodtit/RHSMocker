namespace :demo do
  desc 'Demo seed for onboarding testing'
  task onboarding: :environment do |t, args|
    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, No Credit Card',
                                               premium: true,
                                               skip_credit_card: true)
    ReferralCode.find_or_create_by_name(name: 'Premium, No Credit Card',
                                        code: 'premium',
                                        onboarding_group: o)

    o = OnboardingGroup.find_or_create_by_name(name: 'Trial, No Credit Card',
                                               premium: true,
                                               free_trial_days: 30,
                                               skip_credit_card: true)
    ReferralCode.find_or_create_by_name(name: 'Trial, No Credit Card',
                                        code: 'trial',
                                        onboarding_group: o)

    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, Group',
                                               premium: true,
                                               free_trial_days: 0,
                                               subscription_days: 120,
                                               skip_credit_card: true,
                                               remote_header_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_header.png',
                                               remote_background_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_background.png',
                                               custom_welcome: "This is a onboarding group to use as a test for custom onboarding. It has some placeholder text.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula nulla sed purus pharetra ullamcorper. Donec consectetur est libero, sit amet cursus nisi cursus sed. Nam blandit blandit orci, id lacinia odio luctus sed. Donec sed fermentum massa, id viverra eros.")
    ReferralCode.find_or_create_by_name(name: 'Premium, Group',
                                        code: 'group',
                                        onboarding_group: o)

    title = 'Find a doctor'
    description = <<-eof
We'll find you a doctor close to you who takes your insurance and fits your needs.

**Here's what we'll need from you to find the right fit:**
* Type of doctor
* Your Insurance information
* Your home or work address
* Gender or other preferences

Once we have this, we'll do the search and call each doctors office to ensure the information is up to date. Then we'll send you options of doctors accepting new patients and next available appointment times within one day.

Take 1 minute to share your preferences and we'll take care of the rest.
    eof
    message = "I want to get started finding a new doctor!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)

    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, Group, No Suggested Services',
                                               premium: true,
                                               free_trial_days: 0,
                                               subscription_days: 120,
                                               skip_credit_card: true,
                                               remote_header_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_header.png',
                                               remote_background_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_background.png',
                                               custom_welcome: "This is a onboarding group to use as a test for custom onboarding. It has some placeholder text.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula nulla sed purus pharetra ullamcorper. Donec consectetur est libero, sit amet cursus nisi cursus sed. Nam blandit blandit orci, id lacinia odio luctus sed. Donec sed fermentum massa, id viverra eros.")
    ReferralCode.find_or_create_by_name(name: 'Premium, Group, No Suggested Services',
                                        code: 'group-zero',
                                        onboarding_group: o)

    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, Group, One Suggested Service',
                                               premium: true,
                                               free_trial_days: 0,
                                               subscription_days: 120,
                                               skip_credit_card: true,
                                               remote_header_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_header.png',
                                               remote_background_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_background.png',
                                               custom_welcome: "This is a onboarding group to use as a test for custom onboarding. It has some placeholder text.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula nulla sed purus pharetra ullamcorper. Donec consectetur est libero, sit amet cursus nisi cursus sed. Nam blandit blandit orci, id lacinia odio luctus sed. Donec sed fermentum massa, id viverra eros.")
    ReferralCode.find_or_create_by_name(name: 'Premium, Group, One Suggested Service',
                                        code: 'group-one',
                                        onboarding_group: o)

    title = 'Check your insurance coverage'
    description = "This is placeholder text for insurance coverage review."
    message = "I want to get started reviewing my insurance coverage!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)

    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, Group, Many Suggested Services',
                                               premium: true,
                                               free_trial_days: 0,
                                               subscription_days: 120,
                                               skip_credit_card: true,
                                               remote_header_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_header.png',
                                               remote_background_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_background.png',
                                               custom_welcome: "This is a onboarding group to use as a test for custom onboarding. It has some placeholder text.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula nulla sed purus pharetra ullamcorper. Donec consectetur est libero, sit amet cursus nisi cursus sed. Nam blandit blandit orci, id lacinia odio luctus sed. Donec sed fermentum massa, id viverra eros.")
    ReferralCode.find_or_create_by_name(name: 'Premium, Group, Many Suggested Services',
                                        code: 'group-many',
                                        onboarding_group: o)

    title = 'Check your insurance coverage'
    description = "This is placeholder text for insurance coverage review."
    message = "I want to get started reviewing my insurance coverage!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)

    title = 'Book your post-op appointment'
    description = "This is placeholder text for booking a post-op appointment."
    message = "I want to get started booking my post-op appointment!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)

    title = 'Coordinate your work leave'
    description = "This is placeholder text for coordinating your work leave."
    message = "I want to get started coordinating my work leave!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)

    title = 'Help with your patient guide'
    description = "This is placeholder text for getting help with your patient guide."
    message = "I would like some help understanding my patient guide!"
    service_template = ServiceTemplate.find_by_name('provider search')
    sst = SuggestedServiceTemplate.upsert_attributes({title: title}, {description: description, message: message, service_template: service_template})
    o.suggested_service_templates << sst unless o.suggested_service_templates.include?(sst)
  end

  desc 'Demo Service Template seed with deeply-nested models'
  task service_template: :environment do
    # legacy ServiceType, ServiceTemplates require it for now
    service_type = ServiceType.upsert_attributes!({name: 'appointment booking'}, {bucket: 'care coordination'})

    # create the top level service template
    service_template = ServiceTemplate.find_or_create_by_name(name: "Appointment Booking - Kyle",
                                                              title: "Book appointment with {provider}",
                                                              service_type: service_type,
                                                              description: "Book appointment with Dr. {First Last} for {reason} on {day/time}",
                                                              user_facing: true,
                                                              time_estimate: 90,
                                                              skip_create_initial_task_template_set: true)

    # create task template sets
    task_template_set_1 = service_template.task_template_sets.create!
    task_template_set_2 = service_template.task_template_sets.create!

    # create all task templates
    task_template_1 = task_template_set_1.task_templates.create!(name: 'Book appointment with provider',
                                                             title: 'Book appointment with provider',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 0,
                                                             queue: :specialist,
                                                             service_template: service_template)
    task_template_2 = task_template_set_2.task_templates.create!(name: 'Send member update',
                                                             title: 'Send member update',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 1,
                                                             queue: :pha,
                                                             service_template: service_template)

    task_template_1 = TaskTemplate.find(task_template_1.id)
    task_template_2 = TaskTemplate.find(task_template_2.id)

    # create all data fields used in the service
    dft_member_full_name = service_template.data_field_templates.create!(name: 'Member full name', type: :text, required_for_service_start: true)
    dft_member_date_of_birth = service_template.data_field_templates.create!(name: 'Member date of birth', type: :date, required_for_service_start: true)
    dft_insurance_plan = service_template.data_field_templates.create!(name: 'Insurance plan', type: :text, required_for_service_start: true)
    dft_provider_full_name = service_template.data_field_templates.create!(name: 'Provider full name', type: :text, required_for_service_start: true)
    dft_provider_address = service_template.data_field_templates.create!(name: 'Provider address', type: :text, required_for_service_start: true)
    dft_provider_phone_number = service_template.data_field_templates.create!(name: 'Provider phone number', type: :tel, required_for_service_start: true)
    dft_reason_for_visit = service_template.data_field_templates.create!(name: 'Reason for visit', type: :textarea, required_for_service_start: true)
    dft_new_patient = service_template.data_field_templates.create!(name: 'New patient', type: :boolean, required_for_service_start: true)
    dft_preferred_times = service_template.data_field_templates.create!(name: 'Specific dates/times that work better', type: :textarea, required_for_service_start: true)

    dft_appointment_option_1 = service_template.data_field_templates.create!(name: 'Appointment option 1', type: :datetime, required_for_service_start: false)
    dft_appointment_option_2 = service_template.data_field_templates.create!(name: 'Appointment option 2', type: :datetime, required_for_service_start: false)
    dft_appointment_option_3 = service_template.data_field_templates.create!(name: 'Appointment option 3', type: :datetime, required_for_service_start: false)
    dft_booked_appointment_time = service_template.data_field_templates.create!(name: 'Booked appointment time', type: :datetime, required_for_service_start: false)
    dft_booked_appointment_details = service_template.data_field_templates.create!(name: 'Booked appointment details', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_cancellation_policy = service_template.data_field_templates.create!(name: 'Booked appointment cancellation policy', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_other_information = service_template.data_field_templates.create!(name: 'Booked appointment other information', type: :textarea, required_for_service_start: false)

    # link task template 1 inputs
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_member_full_name)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_member_date_of_birth)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_insurance_plan)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_provider_full_name)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_provider_address)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_provider_phone_number)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_reason_for_visit)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_new_patient)
    task_template_1.input_task_data_field_templates.create!(data_field_template: dft_preferred_times)

    # link task template 1 outputs
    tdft_appointment_option_1 = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_appointment_option_1)
    tdft_appointment_option_2 = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_appointment_option_2)
    tdft_appointment_option_3 = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_appointment_option_3)
    tdft_booked_appointment_time = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_booked_appointment_time)
    tdft_booked_appointment_details = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_booked_appointment_details)
    tdft_booked_appointment_cancellation_policy = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_booked_appointment_cancellation_policy)
    tdft_booked_appointment_other_information = task_template_1.output_task_data_field_templates.create!(data_field_template: dft_booked_appointment_other_information)

    # create steps for task template 1
    CALL_INSTRUCTIONS = <<-eof
* Dial **{Provider phone number}**.
* Introduce yourself:
  * Hi, I'm {YOUR NAME}, a care coordinator for your patient {Member full name}.
  * {Member full name}'s date of birth is {Member date of birth}.
    eof

    task_template_1.task_step_templates.create!(description: "Call provider's office", details: CALL_INSTRUCTIONS)

    CALL_SCRIPT = <<-eof
* I would like to book an appointment for {Member full name} with {Provider full name}.
* {Member full name} wants an appointment because {Reason for visit}.
* What are the next available appointments you have?
    eof

    tst_2 = task_template_1.task_step_templates.create!(description: 'Ask for available appointments', details: CALL_SCRIPT)
    tst_2.task_step_data_field_templates.create!(task_data_field_template: tdft_appointment_option_1, required_for_task_step_completion: true)
    tst_2.task_step_data_field_templates.create!(task_data_field_template: tdft_appointment_option_2, required_for_task_step_completion: true)
    tst_2.task_step_data_field_templates.create!(task_data_field_template: tdft_appointment_option_3, required_for_task_step_completion: true)

    BOOK_SCRIPT = <<-eof
* Dates/times that work for member: {Specific dates/times that work better}
* Check which appointment option matches member’s availability
* Great, I would like to book an appointment with {Provider full name} on...
    eof

    tst_3 = task_template_1.task_step_templates.create!(description: "Book appointment", details: BOOK_SCRIPT)
    tst_3.task_step_data_field_templates.create!(task_data_field_template: tdft_booked_appointment_time, required_for_task_step_completion: true)
    tst_3.task_step_data_field_templates.create!(task_data_field_template: tdft_booked_appointment_details, required_for_task_step_completion: true)
    tst_3.task_step_data_field_templates.create!(task_data_field_template: tdft_booked_appointment_cancellation_policy, required_for_task_step_completion: true)
    tst_3.task_step_data_field_templates.create!(task_data_field_template: tdft_booked_appointment_other_information, required_for_task_step_completion: true)

    CONFIRM_SCRIPT = <<-eof
Confirm information included in the task

> Great! I'd like to confirm the details of this appointment. {Member full name} is scheduled for an appointment with {Provider full name} at {Booked appointment time}.

Confirm cancellation policy

> The cancellation policy for the appointment is "{Booked appointment cancellation policy}".

Confirm other information

> {Booked appointment other information}
    eof

    task_template_1.task_step_templates.create!(description: "Confirm appointment", details: CONFIRM_SCRIPT)

    # link task template 2 inputs
    task_template_2.input_task_data_field_templates.create!(data_field_template: dft_booked_appointment_time)
    task_template_2.input_task_data_field_templates.create!(data_field_template: dft_booked_appointment_details)
    task_template_2.input_task_data_field_templates.create!(data_field_template: dft_booked_appointment_cancellation_policy)
    task_template_2.input_task_data_field_templates.create!(data_field_template: dft_booked_appointment_other_information)

    # create steps for task template 2
    SERVICE_DELIVERABLE = <<-eof
**We booked {Member full name} an appointment with Dr. {Provider full name}.**

Appointment details:

**{Booked appointment time}**
Dr. {Provider full name}
Address: {Provider address}
Phone: {Provider phone number}
Other details: {Booked appointment details}
Cancellation policy: {Booked appointment cancellation policy}
Answers to your questions: {Booked appointment other information}
    eof

    task_template_2.task_step_templates.create!(description: "Update service deliverable", details: "Edit or save the following template to the deliverable for this service.", template: SERVICE_DELIVERABLE)

    MESSAGE_TEMPLATE = <<-eof
**We booked {Member full name} an appointment with Dr. {Provider full name}.**

Appointment details:

**{Booked appointment time}**
Dr. {Provider full name}
Address: {Provider address}
Phone: {Provider phone number}
Other details: {Booked appointment details}
Cancellation policy: {Booked appointment cancellation policy}
Answers to your questions: {Booked appointment other information}
    eof

    task_template_2.task_step_templates.create!(description: "Send update message to member", details: "Edit or send the following template to the member.", template: MESSAGE_TEMPLATE)
  end
end
