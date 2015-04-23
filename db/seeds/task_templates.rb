# Mayo Pilot 2 --

# Week 1

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 2"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHow are you feeling today? As a reminder, I am extension of your care team at Mayo Clinic and here to help out with your transition after the hospital",
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 3"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi___, how are things going?",
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 4"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nJust checking in, ___. How are you today?",
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 5"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ___, Do you have any questions for me as you recuperate?",
                                time_estimate: 1440,
                                priority: 1,
                                service_ordinal: 3})
# Week 2

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 8"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ___, wanted to see how you're doing today?",
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 4})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 10"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nI hope you are doing well ___. Please let me know if I can help out with anything.",
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 5})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 12"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHow are you feeling today, ____?",
                                time_estimate: 2880,
                                priority: 1,
                                service_ordinal: 6})

# Week 3

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 15"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ____. I wanted to check in with you and see how you're doing today.",
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 7})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 18"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nPlease let me know if I can do anything for you, ___. Here to help out!",
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 8})
# Week 4

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 22"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ____. I wanted to check in with you and see how you're doing today.",
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 9})

TaskTemplate.upsert_attributes({name: "mayo pilot 2 - day 25"},
                               {service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
                                title: "Check In with Stroke Patient",
                                description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nPlease let me know if I can do anything for you, ___. Here to help out!",
                                time_estimate: 4320,
                                priority: 1,
                                service_ordinal: 10})

# Provider Search

PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE = <<-eof
1. Go to insurance website and search by:
  * Specialty
  * Distance (5 miles, expand if no options, shorten if >50 options)
  * Preferences
2. Sort search results by distance and export to pdf
3. Go down the list and call providers and ask:
  * Accepts new patients?
  * Accepts insurance plan?
  * Next available appointment? (ex: “late march” not specific date/time)
  * Meets other preferences? (ex. holistic, treats rare disease, LGBTQ friendly, etc)
  * Confirm address?
4. Stop when you have 3 options
5. Open the [“Format Doctor Recommendations” Tool](http://remotehealthservices.github.io/doctor_recommendation_formatter/) and add information for chosen options
6. Search for provider’s profile link (from hospital/clinic) add to tool
7. Google the provider name and location (Dr. First Last, State)
8. Add review links to tool
9. Save templated options to the Service Description
10. Complete Task
11. Save pdf of initial insurance options as “ZipCode_DoctorType.pdf” to [Provider Search Documents Folder](http://goo.gl/V9snYH)
12. Complete task
eof

PROVIDER_SEARCH_SEND_OPTIONS_DESCRIPTION = <<-eof
1. Send options to member (see Service Update for PHA)
2. Complete task
eof

PROVIDER_SEARCH_FOLLOW_UP_DESCRIPTION = <<-eof
1. Send check in message to member

          Just checking in to see what you thought of the providers I sent over. Would you like me to book an appointment with one of them?

2. Complete task
eof

PROVIDER_SEARCH_FOLLOW_UP_DESCRIPTION = <<-eof
1. Go to providers tab in member’s profile
2. Add doctor to profile if they are not already there
3. Complete task
eof

TaskTemplate.upsert_attributes({name: "provider search - find options"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "Find initial provider options",
                                description: PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE,
                                time_estimate: 240,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "provider search -  send options"},
                               {service_template: ServiceTemplate.find_by_name('provider search'),
                                title: "SEND - provider options",
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
                                title: " Confirm or add doctor to profile",
                                description: PROVIDER_SEARCH_ADD_DOCTOR_DESCRIPTION,
                                time_estimate: 4320,
                                service_ordinal: 2})

# Appointment Booking

APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE = <<-eof
1. Call provider office
2. Book appointment that fits member’s preferences
3. **If there is a cancellation fee and the appointment is within 48 hours of calling, don’t book unless urgent appointment**
4. If there is no appointment during member’s preferences:
  * Reassign task to PHA and add to title: “UPDATE -” and include in service description:
    -Explanation (no appts available during preferred time)
    -Available appointment information
    -PHA Next Steps:
      1) Update member and request new preferences
      2) Send task back to HSA with update
  * Call back to book when PHA gets new information from member
  * Book next available appointment only if limited options
5. Once booked, confirm:
  * Time and date of appointment
  * Location
  * Insurance
  * Visit length
  * Cancellation policy
6. Request new patient paperwork for member to complete before visit to be faxed to 866-284-8260
7. Update message in service notes with appointment information
8. Complete task
eof

APPOINTMENT_BOOKING_SEND_CONFIRMATION_DESCRIPTION = <<-eof
1. Send appointment to member (see Service Update for PHA)
2. Complete task
eof

APPOINTMENT_BOOKING_SEND_CALENDAR_DESCRIPTION = <<-eof
1. Send member a calendar invite (see Service Update for PHA)
2. Complete task
eof

APPOINTMENT_BOOKING_ADD_DOCTOR_DESCRIPTION = <<-eof
1. Go to providers tab in member’s profile
2. Add doctor to profile if they are not already there
3. Complete task
eof

APPOINTMENT_BOOKING_REMINDER_TEMPLATE = <<-eof
1. Change due date of this task to day before appointment
2. On due date, send member reminder message with appointment details (see Service Update for PHA)
3. Complete task
eof

APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE = <<-eof
1. Change due date of this task to same day of appointment
2. On due date, send member reminder message:

        How did your appointment go? Do you get all your questions answered?

3. Complete task
eof

TaskTemplate.upsert_attributes({name: "appointment booking - call provider"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "Call provider to book appointment",
                                description: APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "appointment booking -  send confirmation"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "SEND - appointment confirmation",
                                description: APPOINTMENT_BOOKING_SEND_CONFIRMATION_DESCRIPTION,
                                time_estimate: 30,
                                service_ordinal: 1})

TaskTemplate.upsert_attributes({name: "appointment booking - calander invite"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "SEND - calendar invite",
                                description: APPOINTMENT_BOOKING_SEND_CALENDAR_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "appointment booking - add doctor"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: " Confirm or add doctor to profile",
                                description: APPOINTMENT_BOOKING_ADD_DOCTOR_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 2})

TaskTemplate.upsert_attributes({name: "appointment booking - reminder"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "SEND - Appointment reminder",
                                description: APPOINTMENT_BOOKING_REMINDER_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 3})

TaskTemplate.upsert_attributes({name: "appointment booking - appointment follow-up"},
                               {service_template: ServiceTemplate.find_by_name('appointment booking'),
                                title: "SEND - Appointment follow-up",
                                description: APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE,
                                time_estimate: 60,
                                service_ordinal: 3})

#Care Coordination Call

MAKE_CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
1. Make phone call
2. Record who you spoke with and complete notes from call
3. Update “Service Update for PHA”
4. Complete task
eof

CARE_COORDINATION_CALL_SEND_MEMBER_UPDATES_DESCRIPTION = <<-eof
1. Review “Service Update for PHA”
2. Update member
3. Complete PHA next steps (see service description)
eof

TaskTemplate.upsert_attributes({name: "care coordination call - make call"},
                               {service_template: ServiceTemplate.find_by_name('care coordination call'),
                                title: "Make Care Coordination Call",
                                description: MAKE_CARE_COORDINATION_CALL_DESCRIPTION,
                                time_estimate: 60,
                                service_ordinal: 0})

TaskTemplate.upsert_attributes({name: "care coordination call - send update"},
                               {service_template: ServiceTemplate.find_by_name('care coordination call'),
                                title: "Send member update",
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
