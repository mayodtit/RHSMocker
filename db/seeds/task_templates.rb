# Mayo Pilot 2 --

# Week 1
description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

How are you feeling today?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 2"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 0})

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

Is there anything I can help you with today?
eof

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 3"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 1})

description = <<-eof
-If member has not engaged in previous two messages, make outbound call to member to review discharge plan

-Otherwise, check in with engaged patient/about services being performed or use messaging below

Messaging:

Just checking in about your discharge plans. Would you like to set up a time to talk?
eof

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 4"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 2})

description = <<-eof
-If patient is unengaged (has not responded to previous messages and the outbound call), let Paul/Meg know.

-Otherwise, check in with engaged patient/about services being performed or use messaging below

Messaging:

Do you have any questions about your transition plan?
eof

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 5"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 3})
# Week 2

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

How are you doing?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 8"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 4})

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

Is there anything I can help with?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 10"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 5})

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

How are you feeling today?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 12"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 6})

# Week 3
description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

I wanted to check in and see how you're doing today. Let me know if there’s anything I can get started on for you.
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 15"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 7})

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

Please let me know what I can do to help. We’re here to support you.
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 18"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 8})
# Week 4
description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

How’s your week going?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 22"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 9})

description = <<-eof
Check in with engaged patient/about services being performed or use messaging below

Messaging:

How are you feeling today?
eof
TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 25"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: description,
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 10})

# Provider Search

PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE = <<-eof
**This task is assigned to Specialist**

1. Go to insurance website and search by:
  * Specialty
  * Distance (5 miles, expand if no options, shorten if >50 options)
  * Preferences
2. Sort search results by distance and export to PDF
3. Open the [“Format Doctor Recommendations” Tool](http://remotehealthservices.github.io/doctor_recommendation_formatter/)
4. Follow the instructions in the tool to call and gather information about potential providers
5. Copy, paste, and edit the formatted provider options into Service Updates and Service Deliverable Draft - depending on whether most reviews are good or not
6. Copy and paste the provider search notes into Internal Service Notes - Specialist Notes
7. If you have not already, make sure to upload doctors’ photos to database of Providers in Care Portal
8. Save PDF of initial insurance options as “ZipCode_DoctorType.pdf” to [Provider Search Documents Folder](http://goo.gl/V9snYH)
9. Complete Task
eof

PROVIDER_SEARCH_SEND_OPTIONS_DESCRIPTION = <<-eof
**This task is assigned to PHA**

1. Copy, paste, and edit into User-Facing Service Request:

        [mm/dd]: We found you a few [provider type]s who are close to your [location], accepting new patients, and take your insurance. Please take a look at the options below.

2. Copy and paste provider options from Service Deliverable Draft into User-Facing Service Deliverable
3. Send message to member:
        We found you a few [provider type]s who are close to your [location], accepting new patients, and take your insurance.

        [Copy and paste provider options from Service Deliverable Draft here]

        Let us know if you want us to book you an appointment with one, or discuss the options.

4. Complete Task
eof

PROVIDER_SEARCH_FOLLOW_UP_DESCRIPTION = <<-eof
1. Send message to member:

        Just checking in to see what you thought of the [provider type]s I sent over. Let us know if you want to book an appointment with one of them, or if you would like to discuss the options!

2. Complete Task
eof

PROVIDER_SEARCH_ADD_DOCTOR_DESCRIPTION = <<-eof
**This task is assigned to PHA**

**If user selects a provider:**

1. Go to Providers tab in member’s profile and Add Provider
2. Send message to member:

        I’m glad you were able to choose a [provider type] from the options we sent. We’ve also added [Dr. First Last] to your Care Team [here](better://nb?cmd=showCareTeam). Do you want us to help you book an appointment with [him/her]?

3. Copy, paste, and edit into User-Facing Service Request:

        **[mm/dd]: You selected Dr. [First Last] as your dentist.**

4. Complete Task
------------------------------------------------
**If user doesn’t select one of the providers:**

1. Send message to member:

        Let us know if there is anything we can do to expand our search, or help you find better [provider type] options. We’re also here to answer any other questions you have!

2. Copy, paste, and edit into User-Facing Service Request:

        **[mm/dd]: You didn’t select any of the [provider type]s from the options. [Include details about next steps].**

3. Complete Task
eof

TaskTemplate.upsert_attributes({name: "provider search - find options"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "Search - initial provider options",
                                description: PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE,
                                time_estimate: 240,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "provider search -  send options"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "Send member - provider options",
                                description: PROVIDER_SEARCH_SEND_OPTIONS_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "provider search - follow up"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "Follow up - provider options",
                                description: PROVIDER_SEARCH_FOLLOW_UP_DESCRIPTION,
                                time_estimate: 4320,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "provider search - add doctor"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "Confirm and add doctor to profile",
                                description: PROVIDER_SEARCH_ADD_DOCTOR_DESCRIPTION,
                                time_estimate: 4320,
                                service_ordinal: 2})

# Appointment Booking

APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE = <<-eof
**This task is assigned to Specialist**

1. Call provider's office and add notes to Internal Service Notes - Specialist Notes
2. Book appointment that fits member’s preferences (**If there is a cancellation fee, and the appointment is within 48 hours of calling, don’t book unless urgent appointment**)
3. **If there is no appointment during member’s preferences, ask about earliest availability after that:**
  * Reassign task to PHA and add to title: “UPDATE -”. Add the following to Internal Service Updates:
      * Member update:
          - Explanation (no appts available during preferred time)
          - Available appointment information
      * PHA next steps:
          1. Copy, paste, and edit into User-Facing Service Request:

              [mm/dd]: There weren’t any appointments that matched your availability. We’ll book an appointment on another date that works for [you/member name].

          2. Send message to member with member update from Internal Service Updates - Member update and request new availability
          3. Copy, paste and edit this into Internal Service Updates - Specialist next steps:

              [mm/dd]: Messaged member to ask about new availability
              Available dates/times:

          4. Send task back to Specialist with new availability in Internal Service Updates - Specialist next steps

  * Call provider again to book after PHA gets member’s new availability in Internal Service Updates - Specialist next steps
5. Once booked, confirm details with office:
  * Time and date of appointment
  * Location
  * Insurance on file
  * Visit length
  * Cancellation policy
  * If new patient, request new patient paperwork for member to complete before visit to be faxed to 866-284-8260
7. Add appointment information into Service Deliverable Draft
8. Complete Task
eof

APPOINTMENT_BOOKING_SEND_CONFIRMATION_DESCRIPTION = <<-eof
**This task is assigned to PHA**

1. See Service Deliverable Draft
2. Copy and paste appointment details from Service Deliverable Draft into User-Facing Service Deliverable
3. Copy, paste, and edit into User-Facing Service Request:

        **[mm/dd]: We booked [you/member name] an appointment with Dr. [First Last]. The details are below for you to view.**

4. Send this message to member:

        We booked [you/member name] an appointment with Dr. [First Last]. Here are the details of your appointment.

        [Copy and paste appointment details from Service Deliverable Draft]

        We’ve also sent you a calendar reminder via email. Let us know if we need to make any changes!

5. Create an event in Google Calendar - Member Appointment Calendar in the following format:

  Event Title: Appointment with Dr. [First Last]
  Event Location: Address, city
  Calendar: Member Appointment
  Event Description:
  [Copy and paste appointment details from Service Deliverable Draft]
  Add: Member’s email address

  * **Time zone:** Confirm that member’s time zone matches event time zone
  * Save and send invitation to guest


6. Go to Providers tab in member’s profile and Add Provider if not listed
7. If you added Provider, send message to member:

        We’ve also added [Dr. First Last] to your Care Team [here](better://nb?cmd=showCareTeam).

8. Complete Task
eof

APPOINTMENT_BOOKING_REMINDER_TEMPLATE = <<-eof
**This task is assigned to PHA**

1. Change due date of this task to day before appointment
2. On due date, send message to member:

        Remember, [your/member name’s] appointment with Dr. [First Last] is [tomorrow]. Here are the details of the appointment.

        [Copy and paste appointment details from Service Deliverable Draft]

        Can we help [you/member name] prepare for the visit?

3. Complete Task
eof

APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE = <<-eof
**This task is assigned to PHA**

1. Change due date of this task to same day of appointment
2. On due date, send member follow-up message:

        How did your appointment with Dr. [First Last] go? Let us know if we can help with any follow up.

3. Complete Task
eof

TaskTemplate.upsert_attributes({name: "appointment booking - call provider"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "Call - book appointment with provider",
                                description: APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "appointment booking -  send confirmation"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "Send member update - appointment booked",
                                description: APPOINTMENT_BOOKING_SEND_CONFIRMATION_DESCRIPTION,
                                time_estimate: 30,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "appointment booking - reminder"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "Send member - appointment reminder",
                                description: APPOINTMENT_BOOKING_REMINDER_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "appointment booking - appointment follow-up"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "Follow up - appointment",
                                description: APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 3,
                                modal_template: ModalTemplate.find_by_title('Did you add doctor?')})

#Care Coordination Call

MAKE_CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
**This task is assigned to Specialist**

1. Make phone call
2. Record call details and notes in Internal Service Notes - Specialist Notes
3. Update Internal Service Updates - Member update
4. Create follow-up tasks if necessary
5. Complete Task
eof

CARE_COORDINATION_CALL_SEND_MEMBER_UPDATES_DESCRIPTION = <<-eof
**This task is assigned to PHA**

1. See Internal Service Updates - Member update
2. Compose message to member from Specialist’s notes in Service Deliverable Draft section
3. Copy and paste call notes from Service Deliverable Draft into User-Facing Service Deliverable
4. Copy, paste, and edit into User-Facing Service Request:

        **[mm/dd of call]: We spoke with [doctor/insurance/other] about your questions. The notes are below for you to view.**

5. Send message to member:

        We spoke with [doctor/insurance/other] about your questions and we’ve organized the notes for you to review.

        [Copy and paste call notes from Service Deliverable Draft here]

        Let us know if you have any questions!

6. Complete Task
eof

TaskTemplate.upsert_attributes({name: "care coordination call - make call"},
                               {service_template: ServiceTemplate.find_by_name('care coordination call'),
                                title: "Call - care coordination",
                                description: MAKE_CARE_COORDINATION_CALL_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "care coordination call - send update"},
                               {service_template: ServiceTemplate.find_by_name('care coordination call'),
                                title: "Send member update - call notes",
                                description: CARE_COORDINATION_CALL_SEND_MEMBER_UPDATES_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

# PHA Authorization

PHA_AUTHORIZATION_OBTAIN_FORM_DESCRIPTION = <<-eof
1.  Check Google Drive folder for form:
  * [Insurance forms folder](http://goo.gl/tgmqxW)
2. If authorization form not on file
  * Go to insurance website, locate “Forms” section and look for “Authorization to release PHI” form.
  * If unable to find online, call insurance and confirm that you have the right authorization form or have it sent to pha@getbetter OR directly to member if necessary.
3. When you have the correct form, save to drive folder with insurance name (eg “Blue Shield of CA”) as “InsuranceName_AuthorizationForm”
4. Add link to blank form to service description.
5. Complete task
eof

PHA_AUTHORIZATION_SEND_FORM_TO_MEMBER_DESCRIPTION = <<-eof
1. Go to hellosign.com
2. Upload form to hellosign
3. Complete with member’s information
4. Update Hellosign Cover page message

        Please sign the form from your insurance company that allows us to speak on your behalf and obtain information. Let me know if you have any questions. Once it's signed, I'll send it to insurance.

5. Send form to member to sign
6. Complete task
7. Change next task to assign to PHA
eof

PHA_AUTHORIZATION_SIGN_AUTHORIZATION_FORM_DESCRIPTION = <<-eof
1) Send message to member to request that they sign authorization form
> I just sent over an authorization form from [company] for you to sign which allows me to speak on your behalf. You should see an email from HelloSign.com with the form. Please let me know if you have any questions
2) Complete task
eof

PHA_AUTHORIZATION_SEND_FORM_TO_INSURANCE_DESCRIPTION = <<-eof
1. Search for signed form on Hellosign.com using member’s email
2. **If not signed**
  * Assign a task for PHA titled “UPDATE - member needs to sign form” with this message:

            I’ve emailed you an authorization form to sign from Hellosign.com. Let me know if you have any questions. Once it is signed, we’ll send it to your  insurance company. Thanks!

   Change due date of task for 3 days later
3. **If signed**
  * Save signed form to member’s folder in drive as “Signed_<insurance>Authorization”
  * Right click document and choose “Get Link”
  * Save link to signed form to service description and member’s profile under insurance tab
4. Mail **and/or** fax the form to the address/number listed on the form
5. Complete task
6. Change next task to assign to PHA
eof

PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_SENT_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
1. Send member update:

        I've sent the authorization form to your insurance company.  It can take up to 30 days for this form to process. I’ll follow up to make sure it goes through.  In the mean time,  I’ll dial you in for verbal consent if we need to speak to  your insurance company. Do you have any questions?

2. Complete task
eof

PHA_AUTHORIZATION_CALL_CONFIRM_AUTHORIZATION_DESCRIPTION = <<-eof
1. Call insurance company
2. Confirm form was received and is on file
3. **If not received:**
  * Resend authorization form to insurance
  * Reschedule task for 14 days later
  * Assign a task for PHA to update member with this message:

              I checked on the authorization we filed. They did not have it on file. I've sent the authorization form again today.  I’ll follow up in the next few weeks and will let you know when it goes through!

4. **If received:**
  * Go to insurance tab in member’s profile
  * Change “Authorization on file” to “Yes”
5. Complete task
6. Change next task to assign to PHA
eof

PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_ON_FILE_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
1. Send member update:

    The authorization form you signed is on file with your insurance company.  Next time I call over, we shouldn’t need to dial you in for verbal consent!

2. Complete task
eof

TaskTemplate.upsert_attributes({name: "pha authorization - obtain authorization form"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Obtain Authorization Form",
                                description: PHA_AUTHORIZATION_OBTAIN_FORM_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "pha authorization - send form to member"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Send Authorization Form to Member",
                                description: PHA_AUTHORIZATION_SEND_FORM_TO_MEMBER_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "pha authorization - sign authorization form"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Update member - sign authorization form",
                                description: PHA_AUTHORIZATION_SIGN_AUTHORIZATION_FORM_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "pha authorization - send form to insurance"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Send Signed Authorization Form to Insurance",
                                description: PHA_AUTHORIZATION_SEND_FORM_TO_INSURANCE_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "pha authorization - update member authorization sent"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Update member - Authorization form sent",
                                description: PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_SENT_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 3})

TaskTemplate.upsert_attributes({name: "pha authorization - call confirm authorization"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Call - confirm authorization form on file",
                                description: PHA_AUTHORIZATION_CALL_CONFIRM_AUTHORIZATION_DESCRIPTION,
                                time_estimate: 43200,
                                service_ordinal: 4})

TaskTemplate.upsert_attributes({name: "pha authorization - update member authorization on file"},
                               {service_template: ServiceTemplate.find_by_name('pha authorization'),
                                title: "Update member - Authorization form on file",
                                description: PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_ON_FILE_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 5})

# Record Recovery

RECORD_RECOVERY_VERIFY_REQUEST_INFORMATION_DESCRIPTION = <<-eof
1. Call source provider (where records are being collected)
  * Request record release form from source provider
  * Is there a cost for records? (Better will pay up to $20. If more - see Jenn.
  * Does it cost anything for electronic copy of records?
  * How will the records be sent? Fax, secure email, snail mail?
  * How long does it take to process the request? (If necessary - can you expedite it? )
  * Record call notes and representative’s name in service description
2. Call recipient provider to confirm information
  * Verify contact information
  * What is the best way to send records? (fax, mail)
  * How long does it normally take to process?
  * Record notes and representative’s name in service description
eof

RECORD_RECOVERY_COMPLETE_RECORD_REQUEST_FORM_DESCRIPTION = <<-eof
1. Go to hellosign.com
2. Upload form to hellosign
3. Complete with member’s information
4. Update Hellosign Cover page message

        Please review and sign the medical record request form. Let me know if you have any questions.  Once it's signed,  I'll send it to [source hospital] and we'll get your records transferred. Thanks!

5. Send to member via HelloSign to obtain signature
6. Complete task
7. Change next task to assign to PHA
eof

RECORD_RECOVERY_SIGN_AUTHORIZATION_FORM_DESCRIPTION = <<-eof
1. Send message to member to request that they sign authorization form

        I just sent over a record request form for you to sign. Once you do, I’ll send it to your doctor to get your records transferred. Please let me know if you have any questions!

2. Complete task
eof

RECORD_RECOVERY_SEND_FORM_TO_SOURCE_PROVIDER_DESCRIPTION = <<-eof
1. Search for signed form on Hellosign.com using member’s email
2. **If not signed:**
  * Create an update task for PHA with this copy:

            Hi [member], we’re working on getting your records transferred and need your signature. We’ve emailed you an authorization form to sign from pha@getbetter.com using Hellosign.com.  Let me know if you have any questions about the form or using hellosign to sign the document. Once it is signed, we’ll send it to [source provider].*

  * Change due date of task for 3 days later
3. **If signed:**
  * Save signed form to member’s file in drive
  * Save signed form to member’s folder in drive as “Signed_RecordRequest”
  * Right click document and choose “Get Link”
  * Save link to signed form to service description
4. Mail **and/or** fax the form to the address/number listed on the form
5. Complete task
6. Change next task to assign to PHA
eof

RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_SENT_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
1. Send member update:

        I've sent the records release form you signed to [provider]. I’ll call over in the next couple of days to make sure it was received.

2. Complete task
eof

RECORD_RECOVERY_CONFIRM_REQUEST_RECEIVED_DESCRIPTION = <<-eof
1. Call source provider to confirm form was received
2. **If not received:**
  * Check sfax for confirmation of sending, re-confirm fax number/address with source hospital and resend
  * Push back task 1 day
  * Create an update task for PHA with this copy:

            I checked in with [destination hospital] office today and there was a problem on their end so they haven’t received the records request. I’m working with them to fix it and will keep you updated.

3. **If received, ** complete task
4. Change next task to assign to PHA
eof

RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_RECEIVED_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
1. Send member update:

        The medical record request you signed has been received by [source hospital]. They should arrive at [destination hospital] by [date]. I’ll continue to follow up and let you know when they are transferred!

2. Complete task
eof

RECORD_RECOVERY_CONFIRM_RECORDS_TRANSFERRED_DESCRIPTION = <<-eof
1. Call destination provider to confirm records received
2. **If not received:**
  * Call source hospital to find out if they were sent
  * Request that they are resent if needed
  * Create an update task for PHA with this copy:

            [destination hospital] hasn’t received your medical records yet. I’ll call [source hospital]  and have your records resent. I’ll be in touch soon with another update

  * Push back 7 days
3. **If received, ** complete task
4. Change next task to assign to PHA
eof

RECORD_RECOVERY_UPDATE_MEMBER_RECORDS_TRANSFERRED_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
1. Send member update:

        Your medical records have been received by [source hospital] and they have them on file at [destination hospital].

2. Complete task
eof

TaskTemplate.upsert_attributes({name: "record recovery - verify request_informaiton"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Call - Verify Record Request information",
                                description: RECORD_RECOVERY_VERIFY_REQUEST_INFORMATION_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "record recovery - complete record request form"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Complete record request form and send to member",
                                description: RECORD_RECOVERY_COMPLETE_RECORD_REQUEST_FORM_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "record recovery - sign authorization form"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Update member - sign authorization form",
                                description: RECORD_RECOVERY_SIGN_AUTHORIZATION_FORM_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "record recovery - send form to source provider"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Send signed Record Request Form to source provider",
                                description: RECORD_RECOVERY_SEND_FORM_TO_SOURCE_PROVIDER_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 3})

TaskTemplate.upsert_attributes({name: "record recovery - update member request sent"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Update member - record request form sent",
                                description: RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_SENT_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 4})

TaskTemplate.upsert_attributes({name: "record recovery - confirm request received"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Call - Confirm record request form received",
                                description: RECORD_RECOVERY_CONFIRM_REQUEST_RECEIVED_DESCRIPTION,
                                time_estimate: 1440,
                                service_ordinal: 5})

TaskTemplate.upsert_attributes({name: "record recovery - update member request received"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Update member - forms received by source hospital",
                                description: RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_RECEIVED_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 6})

TaskTemplate.upsert_attributes({name: "record recovery - confirm records transferred"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: "Confirm medical records were transferred",
                                description: RECORD_RECOVERY_CONFIRM_RECORDS_TRANSFERRED_DESCRIPTION,
                                time_estimate: 10080,
                                service_ordinal: 7})

TaskTemplate.upsert_attributes({name: "record recovery - update member records transferred"},
                               {service_template: ServiceTemplate.find_by_name('record recovery'),
                                title: " Update member - medical records transferred",
                                description: RECORD_RECOVERY_UPDATE_MEMBER_RECORDS_TRANSFERRED_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 8})

# Prescription Organization

PRESCRIPTION_ORGANIZATION_COLLECT_INFORMATION_DESCRIPTION = <<-eof
1. If member has login to online portal:
  * Login to the member’s account
  * Find list of prescriptions
  * Download list of prescriptions or screenshot information and save to member’s drive (see Step 3)
2. If they don’t have/don’t want a login:
  * Call pharmacy and dial member in for verbal consent if needed
  * Request a list of the member’s Rx be emailed to pha@getbetter.com or faxed to 8662848260
  * Questions to ask pharmacy
  * Do we need written authorization for next time or will their verbal consent today stand?
  * When I call to refill these prescriptions, what info will you need to refill each prescription?
  	* Update service notes and spreadsheet with answers to questions
  * When list received, save list of prescriptions to member’s folder in drive (see Step 3)
3. Save list/screenshot to member’s folder in drive as: *RxList_PharmacyName_MemberName* (ex: RxList_CVS_12345)
4. Repeat for all pharmacies member uses
5. Complete Task
eof

PRESCRIPTION_ORGANIZATION_UPDATE_MEMBER_INFORMATION_RECEIVED_DESCRIPTION = <<-eof
1. Update member that prescription information was received
2. Complete Task

>Hi [member], just an update that we received your prescription information from [pharmacy name]. I’ll update you when we have organized the information and will need you to confirm that we aren’t missing any of your medications.`
eof

PRESCRIPTION_ORGANIZATION_CREATE_SPREADSHEET_DESCRIPTION = <<-eof
1. Go to the [CF Template spreadsheet](https://drive.google.com/open?id=1IDP3_rA9wxmImFeUKYwvpDlSL5sWYBisnstj9p_pjfE&authuser=0)
2. Right click and choose “Make a Copy”
3. Rename to “Prescription Information - [member id]” (ex: Prescription Information - 122345)
4. Move document to member’s folder
5. Right click and choose “Get Link”, copy link and paste in member’s profile and Service Notes
6. Add each prescription to the spreadsheet
7. If missing information (refill dates, number of refills, etc) contact pharmacy or make a task for PHA to ask member directly
8. Complete task
eof

PRESCRIPTION_ORGANIZATION_UPDATE_MEMBER_CONFIRMATION_DESCRIPTION = <<-eof
1. Send member a list of the medications (name only) in a message or email
2. Request that they send the name of any missing supplements or medications
3. Confirm where they fill/purchase any missing meds so you can coordinate refills
4. Save information in spreadsheet
5. Add prescribing doctors to profile
6. Complete task

> Hi [member], here are the medications that I received information on from [pharmacy]. Are there any medications or supplements that are missing?
>   - Item 1
>   - Item 2
>   - Item 3
>   - etc

HCC Messaging:

Service introduction (HCC)

##Identify Service
**M1: **
>`As part of the service we’d like to support you in managing your prescription refills, checking for rebates or discounts, and look at home delivery options through your insurance. We can get your prescription information from your pharmacy so you don’t have to enter it in yourself. Before we get started, are there any medications you need filled immediately? `

**M2: (if yes)**
>`Sounds good, we’ll help you get that refilled as soon as possible`

**Go to Prescription Refills Service**

**M2: (if no)**
>`Great, I have a few questions to get started that will help your PHA [PHA name] start getting your prescriptions organized for you.`

##Collect Information

**M1: **
>`What pharmacy do you use to refill your prescriptions?`

**M2:**
> `Thanks for sharing. If you have one, would you be comfortable sharing with us the login and password to your online [pharmacy name] account? If you don’t have one, we can help you set one up.`

**M3: (if member has log-in)**
> `Thanks! I’ve saved this information securely in your profile. We’ll log in to get the information on your prescriptions. `

**M3: (if member does not have online account)**
> `No problem, we’ll help set it up. Would you like us to make one for you using [email from profile]? If so, this will be the login and we’ll set the password to getbetter123. `

**M3: (does not want online account)**
> `No problem, we’ll call over to your pharmacy to get your prescription information. We’ll need to get your verbal authorization with a short 2 minute call.
What is the best phone number to reach you? OR Is _____ the best number to reach you?
When are you available for a short call?


***Record information in Service Description***

**M4: (confirm insurance) **
>`Sounds good. To confirm, is [insurance] still your current plan?`

##Set Expectation for next steps:
**M1: **
>`We’ll review your prescriptions and confirm with you that they are all up to date. Then we’ll ensure that your prescriptions are filled or delivered on time, that you’re using any available rebates or discounts, and that you can make use of more affordable home delivery options. Your PHA [PHA name] will check in with you tomorrow/later today after they have reviewed your information`

## Offer next service:

Optional:

**M1: **
>`Do you have a good routine for taking your medications? `

**M1:**
>`Do you have any questions about the medications that you take or symptoms from your medications?`

**M1:**
>` Do you have an online portal for your insurance as well? Would you like us to set one up for you? You can view your claims and benefits.`
eof

TaskTemplate.upsert_attributes({name: "prescription organization - collect information"},
                               {service_template: ServiceTemplate.find_by_name('prescription organization'),
                                title: "Collect Prescription Information",
                                description: PRESCRIPTION_ORGANIZATION_COLLECT_INFORMATION_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "prescription organization - send member update - information received"},
                               {service_template: ServiceTemplate.find_by_name('prescription organization'),
                                title: "Send member update - prescription information received",
                                description: PRESCRIPTION_ORGANIZATION_UPDATE_MEMBER_INFORMATION_RECEIVED_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "prescription organization - create spreadsheet"},
                               {service_template: ServiceTemplate.find_by_name('prescription organization'),
                                title: "Save prescription information in spreadsheet",
                                description: PRESCRIPTION_ORGANIZATION_CREATE_SPREADSHEET_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})


TaskTemplate.upsert_attributes({name: "prescription organization - send member - confirmation"},
                               {service_template: ServiceTemplate.find_by_name('prescription organization'),
                                title: "Send member update - confirm all prescriptions are on file",
                                description: PRESCRIPTION_ORGANIZATION_UPDATE_MEMBER_CONFIRMATION_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 3})

# Appointment Preparation - CF
APPOINTMENT_PREPARATION_CF_CHECK_IN_MONTH_DESCRIPTION = <<-eof
**Change due date of this task to 1 month before appointment**
1. On due date, send details about appointment
2. Check in about new symptoms, nutrition or medication questions
3. Add recorded BMI measurements to **Service Update for PHA** and remind to enter BMI
4. Update confirmed appointment, new symptoms or questions in **Service Update for PHA**
5. Complete task

**M1:**
Hi [member], a reminder that your next CF appointment with Dr. [doctor name] is 1 month away! Here are the details of the appointment:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number

Does this still work with your schedule?

**M2 (if they’ve been tracking BMI):**
Great! Thanks for entering your BMI measurements. Keep up the good work.

**M2 (if they haven’t been tracking BMI):**
Just a reminder to keep up the daily weight measurements and save it to your profile by [tapping here](better://nb?cmd=showMedicalInformation).

**M3:**
Do you have any questions about your medications, nutrition or new symptoms? Send them here and I’ll keep track of them to ask your doctor at your appointment.
eof

APPOINTMENT_PREPARATION_CF_CHECK_IN_WEEK_DESCRIPTION = <<-eof
**Change due date of this task to 1 week before appointment**
1. On due date, send details about appointment and find out how they are getting there
2. Check in about new symptoms, nutrition or medication questions
3. Add recorded BMI measurements to **Service Update for PHA** and remind to enter BMI
4. Update confirmed appointment, new symptoms or questions in **Service Update for PHA**
5. Complete task


**M1:**
Hi [member], a reminder that your next CF appointment with Dr. [doctor name] is 1 month away! Here are the details of the appointment:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number

How are you planning on getting to your appointment?

**M2 (if they’ve been tracking BMI):**
Great! Thanks for entering your BMI measurements. Keep up the good work.

**M2 (if they haven’t been tracking BMI):**
Just a reminder to keep up the daily weight measurements and save it to your profile by [tapping here](better://nb?cmd=showMedicalInformation).

**M3:**
Do you have any questions about your medications, nutrition or new symptoms? Send them here and I’ll keep track of them to ask your doctor at your appointment.
eof

APPOINTMENT_PREPARATION_CF_CHECK_IN_DAY_DESCRIPTION = <<-eof
**Change due date of this task to 1 day before appointment**
1. On due date, send details about appointment
2. Send member information recorded in Service Notes
3. Complete task

**M1:**
Hi [member], a reminder that your next CF appointment with Dr. [doctor name] is tomorrow! Here are the details of the appointment:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number

**M2:**
Over the last month we’ve been collecting information to help prepare you for your appointment. Here are some things to review with your doctor:

**New symptoms:**

**Current BMI:**

**BMI measurements since your last visit:**
<BMI>, <date>

**Medication questions:**
Are you making any changes to my medications?
If so, how will that affect me?
**Nutrition questions:**
Would you recommend I change any of my eating habits?


**M3:**
I’ll check in with you after your appointment! Let me know if you’d like me to email this to you as well.
eof

APPOINTMENT_PREPARATION_CF_FOLLOW_UP_DESCRIPTION = <<-eof
*Change due date of this task to same day of appointment**
1. On due date, ask how appointment went
2. If they scheduled the next one, add to calendar and assign new Appointment Preparation service due the day of new appointment
3. If they did not schedule the next one, create Appointment Booking service
4. Record any notes from the visit to the member’s profile
5. Assign new services as necessary
6. Complete task

**M1:**
How did your appointment go today? Did Dr. [doctor name] suggest any changes to your medications, nutrition or treatment plan?

**M2:**
Did you already schedule your next appointment?

**M3 (if yes):**
Great! I’ll add it to your calendar and help you prepare like I did with this appointment.

**M3 (if no):**
Is there any particular reason it was not scheduled? We can call over and get your next appointment on the calendar for you.
eof

TaskTemplate.upsert_attributes({name: "appointment preparation - cf - check in - month"},
                               {service_template: ServiceTemplate.find_by_name('appointment preparation - cf'),
                                title: "CF Appointment Check in - 1 month",
                                description: APPOINTMENT_PREPARATION_CF_CHECK_IN_MONTH_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "appointment preparation - cf - check in - week"},
                               {service_template: ServiceTemplate.find_by_name('appointment preparation - cf'),
                                title: " CF Appointment Check in - 1 week",
                                description: APPOINTMENT_PREPARATION_CF_CHECK_IN_WEEK_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "appointment preparation - cf - check in - day"},
                               {service_template: ServiceTemplate.find_by_name('appointment preparation - cf'),
                                title: "CF Appointment Check in - 1 day",
                                description: APPOINTMENT_PREPARATION_CF_CHECK_IN_DAY_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})


TaskTemplate.upsert_attributes({name: "appointment preparation - cf - follow up"},
                               {service_template: ServiceTemplate.find_by_name('appointment preparation - cf'),
                                title: "CF Appointment Follow Up",
                                description: APPOINTMENT_PREPARATION_CF_FOLLOW_UP_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 3})

# BMI Management

BMI_MANAGEMENT_3_MONTHS_INITIAL_TASK_DESCRIPTION = <<-eof
1. Change due date of this task to 1 business day before first weigh in (ex. if Monday, schedule task for Friday. If Tuesday, schedule task for Monday, etc)
2. Schedule a reminder message **due at the time they weigh in** (copy below)
3. Complete task
>Hi [member], it’s time for a weigh-in! Go ahead and weigh yourself and [enter it here](better://nb?cmd=showMedicalInformation) or send it in a message.
eof

BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_A_DESCRIPTION = <<-eof
1. Schedule a reminder message due at the time they weigh in (copy below)
2. Complete task
>Hi [member], it’s time for a weigh-in! Go ahead and weigh yourself and [enter it here](better://nb?cmd=showMedicalInformation) or send it in a message.
eof

BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_B_DESCRIPTION = <<-eof
1. Schedule a reminder message due at the time they weigh in (copy below)
2. Complete task
> It’s that time again! [Enter your weight here](better://nb?cmd=showMedicalInformation) and I’ll keep track of your progress.
eof

BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_C_DESCRIPTION = <<-eof
1. Schedule a reminder message due at the time they weigh in (copy below)
2. Complete task
> Hi there [member] - just a reminder for your weekly weigh-in! Hop on that scale and [enter your weight here](better://nb?cmd=showMedicalInformation) or send it in a message.
eof

BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_D_DESCRIPTION = <<-eof
1. Schedule a reminder message due at the time they weigh in (copy below)
2. Complete task
> Time to weigh yourself! After you do, [tap here to enter it in your profile](better://nb?cmd=showMedicalInformation) or send it to me in a message.
eof

BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION = <<-eof
1. Check messages and profile to see if member sent or entered their weight for that day
2. If yes, save BMI and date in **Service Update**, **Service Deliverable** and enter into member’s profile (unless HCC has done so)
3. Send message
4. Complete task

**If weight sent/entered:**
>Thanks for entering your weight - keep up the good work! I’ll remind you again next week.

**If not:**
>Hi [member], did you get a chance to weigh yourself today?

* Dig in to what blocked them from weighing in today
eof

BMI_MANAGEMENT_3_MONTHS_COMPILE_BMI_DESCRIPTION = <<-eof
1. Confirm that all BMI measurements entered in the member’s profile are saved in the **Service Update** and **Service Deliverable**
2. Add to Service Deliverable:
  Overall, your BMI [increased/decreased/stayed the same]. Here are the measurements to show Dr. [doctor name] at your next visit:
3. Send member a message updating them
Hi [member], I’ve saved the progress of your last 3 months of BMI tracking. You can see details in the Services section of the app. Here are the measurements to show Dr. [doctor name] at your next visit:
	* **BMI and date:**
eof

TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 1"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 1",
                                description: BMI_MANAGEMENT_3_MONTHS_INITIAL_TASK_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 1"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 1",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 1})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weighh 2"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 2",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_B_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 2})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 2"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 2",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 3})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 3"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 3",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_C_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 4})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 3"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 3",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 5})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 4"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 4",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_D_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 6})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 4"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 4",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 7})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 5"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 5",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_A_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 8})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 5"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 5",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 9})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 6"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 6",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_B_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 10})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 6"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 6",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 11})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 7"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 8",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_C_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 12})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 7"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 7",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 13})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 8"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 8",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_D_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 14})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 8"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 8",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 15})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 9"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 9",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_A_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 16})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 9"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 9",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 17})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 10"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 10",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_B_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 18})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 10"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 10",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 19})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 11"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 11",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_C_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 20})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 11"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 11",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 21})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - schedule reminder - weigh 12"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Schedule reminder - Weigh-In 12",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_A_MESSAGE_D_DESCRIPTION,
                                time_estimate: 7200,
                                service_ordinal: 22})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - follow up - weigh 12"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 12",
                                description: BMI_MANAGEMENT_3_MONTHS_TASK_B_DESCRIPTION,
                                time_estimate: 2880,
                                service_ordinal: 23})
TaskTemplate.upsert_attributes({name: "bmi management - 3 months - compile BMI"},
                               {service_template: ServiceTemplate.find_by_name('bmi management - 3 months'),
                                title: "Follow up - Weigh-In 10",
                                description: BMI_MANAGEMENT_3_MONTHS_COMPILE_BMI_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 24})
