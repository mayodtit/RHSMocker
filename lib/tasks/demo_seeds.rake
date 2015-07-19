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
                                                              user_facing: true,
                                                              time_estimate: 90)

    # create all task templates
    task_template_1 = service_template.task_templates.create!(name: 'Book appointment with provider',
                                                             title: 'Book appointment with provider',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 0)
    task_template_2 = service_template.task_templates.create!(name: 'Send member update',
                                                             title: 'Send member update',
                                                             description: 'description',
                                                             time_estimate: 60,
                                                             service_ordinal: 1)

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
