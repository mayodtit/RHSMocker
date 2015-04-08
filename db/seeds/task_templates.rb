# Mayo Pilot 2 --
# Week 1
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 2",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHow are you feeling today? As a reminder, I am extension of your care team at Mayo Clinic and here to help out with your transition after the hospital",
    time_estimate: 1440,
    priority: 1,
    service_ordinal: 0
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 3",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi___, how are things going?",
    time_estimate: 1440,
    priority: 1,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 4",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nJust checking in, ___. How are you today?",
    time_estimate: 1440,
    priority: 1,
    service_ordinal: 2
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 5",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ___, Do you have any questions for me as you recuperate?",
    time_estimate: 1440,
    priority: 1,
    service_ordinal: 3
)
# Week 2
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 8",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ___, wanted to see how you're doing today?",
    time_estimate: 2880,
    priority: 1,
    service_ordinal: 4
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 10",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nI hope you are doing well ___. Please let me know if I can help out with anything.",
    time_estimate: 2880,
    priority: 1,
    service_ordinal: 5
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 12",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHow are you feeling today, ____?",
    time_estimate: 2880,
    priority: 1,
    service_ordinal: 6
)
# Week 3
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 15",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ____. I wanted to check in with you and see how you're doing today.",
    time_estimate: 4320,
    priority: 1,
    service_ordinal: 7
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 18",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nPlease let me know if I can do anything for you, ___. Here to help out!",
    time_estimate: 4320,
    priority: 1,
    service_ordinal: 8
)
# Week 4
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 22",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nHi ____. I wanted to check in with you and see how you're doing today.",
    time_estimate: 4320,
    priority: 1,
    service_ordinal: 9
)
TaskTemplate.find_or_create_by_name(
    name: "mayo pilot 2 - day 25",
    service_template: ServiceTemplate.find_by_name('mayo pilot 2'),
    title: "Check In with Stroke Patient",
    description: "*Check in with engaged patient/about services being performed or use messaging below:*\n**Messaging**\nPlease let me know if I can do anything for you, ___. Here to help out!",
    time_estimate: 4320,
    priority: 1,
    service_ordinal: 10
)

PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE = <<-eof
1. Go to insurance website and search by:
  * Specialty
  * Distance (5 miles, expand if no options, shorten if >50 options)
  * Preferences
1. Sort search results by distance
1. Go down the list and call providers and ask:
  * Accepts new patients?
  * Accepts insurance plan?
  * Next available appointment? (ex: “late march” not specific date/time)
  * Meets other preferences? (ex. holistic, treats rare disease, LGBTQ friendly, etc)
  * Confirm address?
1. Stop when you have 3 options
1. Open the [“Format Doctor Recommendations” Tool](http://remotehealthservices.github.io/doctor_recommendation_formatter/) and add information for chosen options
1. Search for provider’s profile link (from hospital/clinic) add to tool
1. Google the provider name and location (Dr. First Last, State)
1. Add review links to tool
1. Save templated options to the Service Description
1. Complete Task
1. Save pdf of initial insurance options as “ZipCode_DoctorType.pdf” to [Provider Search Documents Folder](http://goo.gl/V9snYH)

**CP Doctor List template (save to Task Notes in CP):**
Dr. name:
Address:
Phone:
Profile link:
Accepting patients:
Takes insurance:
Next available:
eof

# Provider Search
TaskTemplate.find_or_create_by_name(
    name: "provider search - find options",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Find initial provider options",
    description: PROVIDER_SEARCH_FIND_OPTIONS_TEMPLATE,
    time_estimate: 240,
    service_ordinal: 0
)
TaskTemplate.find_or_create_by_name(
    name: "provider search -  send options",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "SEND - provider options",
    description: "Send options to Member (see service notes)",
    time_estimate: 60,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "provider search - follow up",
    service_template: ServiceTemplate.find_by_name('provider search'),
    title: "Follow up - provider options",
    description: "Just checking in to see what you thought of the providers I sent over. Would you like me to book an appointment with one of them?",
    time_estimate: 4320,
    service_ordinal: 2
)

# Appointment Booking

APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE = <<-eof
1. Call provider office
1. Book appointment that fits member’s preferences
1. **If there is a cancellation fee and the appointment is within 48 hours of calling, don’t book unless urgent appointment**
1. If there is no appointment during member’s preferences:
  * Reassign task to PHA and add to title: “UPDATE -” and include in service description:
    - Explanation (no appts available during preferred time)
    - Available appointment information
    - PHA Next Steps:
      1) Update member and request new preferences
      2) Send task back to HSA with update
  * Call back to book when PHA gets new information from member
  * Book next available appointment only if limited options
1. Once booked, confirm:
  * Time and date of appointment
  * Location
  * Insurance
  * Visit length
  * Cancellation policy
1. Request new patient paperwork for member to complete before visit to be faxed to 866-284-8260
1. Update message in service notes with appointment information
1. Complete task

---------------------------------------------------------
Call notes:

Who you spoke with:
Available times/Booked time:
Insurance still up-to-date:
What to bring:
Special instructions to prepare:

---------------------------------------------------------
eof

APPOINTMENT_BOOKING_REMINDER_TEMPLATE = <<-eof
* Change due date of this task to day before appointment
* On due date, send member reminder message with appointment details (See service notes)
eof

APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE = <<-eof
* Change due date of this task to same day of appointment
* On due date, send member reminder message:
  *How did your appointment go? Do you get all your questions answered?” *
eof

TaskTemplate.find_or_create_by_name(
    name: "appointment booking - call provider",
    service_template: ServiceTemplate.find_by_name('appointment booking'),
    title: "Call provider to book appointment",
    description: APPOINTMENT_BOOKING_CALL_PROVIDER_TEMPLATE,
    time_estimate: 60,
    service_ordinal: 0
)
TaskTemplate.find_or_create_by_name(
    name: "appointment booking -  send confirmation",
    service_template: ServiceTemplate.find_by_name('appointment booking'),
    title: "SEND - appointment confirmation",
    description: "Send appointment to Member (see service notes)",
    time_estimate: 30,
    service_ordinal: 1
)
TaskTemplate.find_or_create_by_name(
    name: "appointment booking - calander invite",
    service_template: ServiceTemplate.find_by_name('appointment booking'),
    title: "SEND - calendar invite",
    description: "Send member a calendar invite (See service notes)",
    time_estimate: 60,
    service_ordinal: 2
)
TaskTemplate.find_or_create_by_name(
    name: "appointment booking - reminder",
    service_template: ServiceTemplate.find_by_name('appointment booking'),
    title: "Appointment reminder",
    description: APPOINTMENT_BOOKING_REMINDER_TEMPLATE,
    time_estimate: 60,
    service_ordinal: 2
)
TaskTemplate.find_or_create_by_name(
    name: "appointment booking - appointment follow-up",
    service_template: ServiceTemplate.find_by_name('appointment booking'),
    title: "SEND - Appointment follow-up",
    description: APPOINTMENT_BOOKING_FOLLOW_UP_TEMPLATE,
    time_estimate: 60,
    service_ordinal: 2
)

#Care Coordination Call

MAKE_CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
1. Make phone call
1. Record who you spoke with and complete notes from call
1. Update Member update
1. Update PHA next steps (if needed)
eof

TaskTemplate.find_or_create_by_name(
    name: "care coordination call - make call",
    service_template: ServiceTemplate.find_by_name('care coordination call'),
    title: "Make Care Coordination Call",
    description: MAKE_CARE_COORDINATION_CALL_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 0
)

CARE_COORDINATION_CALL_SEND_MEMBER_UPDATES_DESCRIPTION = <<-eof
1. Update member
1. Complete PHA next steps (see service description)
eof

TaskTemplate.find_or_create_by_name(
    name: "care coordination call - send update",
    service_template: ServiceTemplate.find_by_name('care coordination call'),
    title: "Send member update",
    description: CARE_COORDINATION_CALL_SEND_MEMBER_UPDATES_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 1
)

# PHA Authorization

PHA_AUTHORIZATION_OBTAIN_FORM_DESCRIPTION = <<-eof
1.  Check Google Drive folder for form:
  * [Insurance forms folder](http://goo.gl/tgmqxW)
1. If authorization form not on file
  * Go to insurance website, locate “Forms” section and look for “Authorization to release PHI” form.
  * If unable to find online, call insurance and confirm that you have the right authorization form or have it sent to pha@getbetter OR directly to member if necessary.
1. When you have the correct form, save to drive folder with insurance name (eg “Blue Shield of CA”) as “InsuranceName_AuthorizationForm”
1. Add link to blank form to service description.
1. Complete task
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - obtain authorization form",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Obtain Authorization Form",
    description: PHA_AUTHORIZATION_OBTAIN_FORM_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 0
)

PHA_AUTHORIZATION_SEND_FORM_TO_MEMBER_DESCRIPTION = <<-eof
1. Go to hellosign.com
1. Upload form to hellosign
1. Complete with member’s information
1. Review with 1 other Specialist team member by making a task assigned to them with the link to the form
1. Send form to member to sign
1. Complete task

#Hellosign Cover Page message
Please sign the form from your insurance company that allows us to speak on your behalf and obtain information. Let me know if you have any questions. Once it's signed, I'll send it to insurance.
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - send form to member",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Send Authorization Form to Member",
    description: PHA_AUTHORIZATION_SEND_FORM_TO_MEMBER_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 0
)

PHA_AUTHORIZATION_SEND_FORM_TO_INSURANCE_DESCRIPTION = <<-eof
1. Search for signed form on Hellosign.com using member’s email
1. **If not signed**
  * Assign a task for PHA titled “UPDATE - member needs to sign form” with this message:
I’ve emailed you an authorization form to sign from Hellosign.com. Let me know if you have any questions. Once it is signed, we’ll send it to your insurance company. Thanks!
  * Change due date of task for 3 days later
1. **If signed**
  * Save signed form to member’s folder in drive as “Signed_<insurance>Authorization”
  * Right click document and choose “Get Link”
  * Save link to signed form to service description and member’s profile under insurance tab
1. Mail **and/or** fax the form to the address/number listed on the form
1. Complete task
1. Change next task to assign to PHA
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - send form to insurance",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Send Signed Authorization Form to Insurance",
    description: PHA_AUTHORIZATION_SEND_FORM_TO_INSURANCE_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 1
)

PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_SENT_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
Signed authorization form has been sent to insurance.

1. Send member update:

  I've sent the authorization form to your insurance company. It can take up to 30 days for this form to process. I’ll follow up to make sure it goes through. In the mean time, I’ll dial you in for verbal consent if we need to speak to your insurance company. Do you have any questions?
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - update member authorization sent",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Update member - Authorization form sent",
    description: PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_SENT_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 2
)

PHA_AUTHORIZATION_CALL_CONFIRM_AUTHORIZATION_DESCRIPTION = <<-eof
1. Call insurance company
1. Confirm form was received and is on file
1. **If not received:**
  * Resend authorization form to insurance
  * Reschedule task for 14 days later
  * Assign a task for PHA to update member with this message:
I checked on the authorization we filed. They did not have it on file. I've sent the authorization form again today. I’ll follow up in the next few weeks and will let you know when it goes through!
1. **If received:**
  * Go to insurance tab in member’s profile
  * Change “Authorization on file” to “Yes”
1. Complete task
1. Change next task to assign to PHA
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - call confirm authorization",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Call - confirm authorization form on file",
    description: PHA_AUTHORIZATION_CALL_CONFIRM_AUTHORIZATION_DESCRIPTION,
    time_estimate: 43200,
    service_ordinal: 3
)

PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_ON_FILE_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
Signed authorization form is on file with insurance

1. Send member update:

  The authorization form you signed is on file with your insurance company. Next time I call over, we shouldn’t need to dial you in for verbal consent!
eof

TaskTemplate.find_or_create_by_name(
    name: "pha authorization - update member authorization on file",
    service_template: ServiceTemplate.find_by_name('pha authorization'),
    title: "Update member - Authorization form on file",
    description: PHA_AUTHORIZATION_UPDATE_MEMBER_AUTHORIZATION_ON_FILE_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 4
)

# Record Recovery

RECORD_RECOVERY_VERIFY_REQUEST_INFORMATION_DESCRIPTION = <<-eof
1. Call source provider (where records are being collected)
  * Request record release form from source provider
  * Is there a cost for records? (Better will pay up to $20. If more - see Jenn.
  * Does it cost anything for electronic copy of records?
  * How will the records be sent? Fax, secure email, snail mail?
  * How long does it take to process the request? (If necessary - can you expedite it? )
  * Record call notes and representative’s name in service description
1. Call recipient provider to confirm information
  * Verify contact information
  * What is the best way to send records? (fax, mail)
  * How long does it normally take to process?
  * Record notes and representative’s name in service description
---------------------------------------------------------
Call notes:
Office representative:
Verified contact information: yes/no
Form: website/faxed to better/email
Cost:
Turnaround time:
Other:

---------------------------------------------------------
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - verify request_informaiton",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Call - Verify Record Request information",
    description: RECORD_RECOVERY_VERIFY_REQUEST_INFORMATION_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 0
)

RECORD_RECOVERY_COMPLETE_RECORD_REQUEST_FORM_DESCRIPTION = <<-eof
1. Go to hellosign.com
1. Upload form to hellosign
1. Complete with member’s information
1. Send to member via HelloSign to obtain signature
1. Complete task

**HelloSign message template:**
Hi [member], please review and sign the medical record request form. Let me know if you have any questions. Once it's signed, I'll send it to [source hospital] and we'll get your records transferred. Thanks!
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - complete record request form",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Complete record request form and send to member",
    description: RECORD_RECOVERY_COMPLETE_RECORD_REQUEST_FORM_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 1
)

RECORD_RECOVERY_SEND_FORM_TO_SOURCE_PROVIDER_DESCRIPTION = <<-eof
1. Search for signed form on Hellosign.com using member’s email
1. **If not signed:**
  * Create an update task for PHA with this copy:
    Hi [member], we’re working on getting your records transferred and need your signature. We’ve emailed you an authorization form to sign from pha@getbetter.com using Hellosign.com.  Let me know if you have any questions about the form or using hellosign to sign the document. Once it is signed, we’ll send it to [source provider].
  * Change due date of task for 3 days later
1. **If signed:**
  * Save signed form to member’s file in drive
  * Save signed form to member’s folder in drive as “Signed_RecordRequest”
  * Right click document and choose “Get Link”
  * Save link to signed form to service description
1. Mail **and/or** fax the form to the address/number listed on the form
1. Complete task
1. Change next task to assign to PHA
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - send form to source provider",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Send signed Record Request Form to source provider",
    description: RECORD_RECOVERY_SEND_FORM_TO_SOURCE_PROVIDER_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 2
)

RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_SENT_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
Signed records release form has been sent to source hospital

1. Send member update message:

  I've sent the records release form you signed to [provider]. I’ll call over in the next couple of days to make sure it was received.
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - update member request sent",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Update member - record request form sent",
    description: RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_SENT_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 3
)

RECORD_RECOVERY_CONFIRM_REQUEST_RECEIVED_DESCRIPTION = <<-eof
1. Call source provider to confirm form was received
1. **If not received:**
  * Check sfax for confirmation of sending, re-confirm fax number/address with source hospital and resend
  * Push back task 1 day
  * Create an update task for PHA with this copy:
I checked in with [destination hospital] office today and there was a problem on their end so they haven’t received the records request. I’m working with them to fix it and will keep you updated.
1. **If received, ** complete task
1. Change next task to assign to PHA
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - confirm request received",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Call - Confirm record request form received",
    description: RECORD_RECOVERY_CONFIRM_REQUEST_RECEIVED_DESCRIPTION,
    time_estimate: 1440,
    service_ordinal: 4
)

RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_RECEIVED_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
Records release received by source hospital

1. Send member update message:

  The medical record request you signed has been received by [source hospital]. They should arrive at [destination hospital] by [date]. I’ll continue to follow up and let you know when they are transferred!

eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - update member request received",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Update member - forms received by source hospital",
    description: RECORD_RECOVERY_UPDATE_MEMBER_REQUEST_RECEIVED_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 5
)

RECORD_RECOVERY_CONFIRM_RECORDS_TRANSFERRED_DESCRIPTION = <<-eof
1. Call destination provider to confirm records received
1. **If not received:**
  * Call source hospital to find out if they were sent
  * Request that they are resent if needed
  * Create an update task for PHA with this copy:
    [destination hospital] hasn’t received your medical records yet. I’ll call [source hospital]  and have your records resent. I’ll be in touch soon with another update
  * Push back 7 days
1. **If received, ** complete task
1. Change next task to assign to PHA
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - confirm records transferred",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: "Confirm medical records were transferred",
    description: RECORD_RECOVERY_CONFIRM_RECORDS_TRANSFERRED_DESCRIPTION,
    time_estimate: 10080,
    service_ordinal: 6
)

RECORD_RECOVERY_UPDATE_MEMBER_RECORDS_TRANSFERRED_DESCRIPTION = <<-eof
**Will be assigned to Specialist, reassign to PHA**
Medical records have been received by source hospital

1. Send member update message:

  Your medical records have been received by [source hospital] and they have them on file at [destination hospital].
eof

TaskTemplate.find_or_create_by_name(
    name: "record recovery - update member records transferred",
    service_template: ServiceTemplate.find_by_name('record recovery'),
    title: " Update member - medical records transferred",
    description: RECORD_RECOVERY_UPDATE_MEMBER_RECORDS_TRANSFERRED_DESCRIPTION,
    time_estimate: 60,
    service_ordinal: 7
)
