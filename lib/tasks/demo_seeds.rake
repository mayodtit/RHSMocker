namespace :seeds do
  desc 'Demo seed'
  task kyle: :environment do
    # legacy ServiceType, ServiceTemplates require it for now
    service_type = ServiceType.upsert_attributes!({name: 'appointment booking'}, {bucket: 'care coordination'})

    # create the top level service template
    service_template = ServiceTemplate.find_or_create_by_name(name: "Appointment Booking - Kyle",
                                                              title: "Book appointment with {provider}",
                                                              service_type: service_type,
                                                              description: "Book appointment with Dr. {First Last} for {reason} on {day/time}",
                                                              user_facing: true)

    # create all task templates
    task_template_1 = service_template.task_templates.create(name: 'Book appointment with provider',
                                                             title: 'Book appointment with provider',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 0)
    task_template_2 = service_template.task_templates.create(name: 'Send member update',
                                                             title: 'Send member update',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 1)

    # create steps for task template 1
    task_template_1.task_step_templates.create(description: 'Call the office')
    task_template_1.task_step_templates.create(description: 'Introduce yourself and make request')
    task_template_1.task_step_templates.create(description: "If this matches, the user's request, book it")
    task_template_1.task_step_templates.create(description: "Otherwise, mark as blocked")

    # create steps for task template 2
    task_template_2.task_step_templates.create(description: "Send update to member")

    # create all data fields used in the service
    dft_member_full_name = service_template.data_field_templates.create(name: 'Member full name', type: :string, required_for_service_start: true)
    dft_member_date_of_birth = service_template.data_field_templates.create(name: 'Member date of birth', type: :date, required_for_service_start: true)
    dft_insurance_plan = service_template.data_field_templates.create(name: 'Insurance plan', type: :string, required_for_service_start: true)
    dft_provider_full_name = service_template.data_field_templates.create(name: 'Provider full name', type: :string, required_for_service_start: true)
    dft_provider_address = service_template.data_field_templates.create(name: 'Provider address', type: :string, required_for_service_start: true)
    dft_provider_phone_number = service_template.data_field_templates.create(name: 'Provider phone number', type: :string, required_for_service_start: true)
    dft_reason_for_visit = service_template.data_field_templates.create(name: 'Reason for visit', type: :textarea, required_for_service_start: true)
    dft_new_patient = service_template.data_field_templates.create(name: 'New patient', type: :boolean, required_for_service_start: true)
    dft_preferred_times = service_template.data_field_templates.create(name: 'Specific dates/times that work better', type: :textarea, required_for_service_start: true)

    dft_appointment_option_1 = service_template.data_field_templates.create(name: 'Appointment option 1', type: :textarea, required_for_service_start: false)
    dft_appointment_option_2 = service_template.data_field_templates.create(name: 'Appointment option 2', type: :textarea, required_for_service_start: false)
    dft_appointment_option_3 = service_template.data_field_templates.create(name: 'Appointment option 3', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_time = service_template.data_field_templates.create(name: 'Booked appointment time', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_details = service_template.data_field_templates.create(name: 'Booked appointment details', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_cancellation_policy = service_template.data_field_templates.create(name: 'Booked appointment cancellation policy', type: :textarea, required_for_service_start: false)
    dft_booked_appointment_other_information = service_template.data_field_templates.create(name: 'Booked appointment other information', type: :textarea, required_for_service_start: false)

    # link task template 1 inputs
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_member_full_name)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_member_date_of_birth)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_insurance_plan)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_provider_full_name)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_provider_address)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_provider_phone_number)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_reason_for_visit)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_new_patient)
    task_template_1.input_task_data_field_templates.create(data_field_template: dft_preferred_times)

    # link task template 1 outputs
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_appointment_option_1)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_appointment_option_2)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_appointment_option_3)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_booked_appointment_time)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_booked_appointment_details)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_booked_appointment_cancellation_policy)
    task_template_1.output_task_data_field_templates.create(data_field_template: dft_booked_appointment_other_information)

    # link task template 2 inputs
    task_template_2.input_task_data_field_templates.create(data_field_template: dft_booked_appointment_time)
    task_template_2.input_task_data_field_templates.create(data_field_template: dft_booked_appointment_details)
    task_template_2.input_task_data_field_templates.create(data_field_template: dft_booked_appointment_cancellation_policy)
    task_template_2.input_task_data_field_templates.create(data_field_template: dft_booked_appointment_other_information)
  end
end
