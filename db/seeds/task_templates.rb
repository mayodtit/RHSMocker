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
1. **If there is a cancellation fee and the appointment is within 48 hours of calling, don’t book unless member confirms**
1. If there is no appointment during member’s preferences
 * Collect next available appointments
 * Assign PHA a task titled “UPDATE - no available appointments, get new option” and include available appointment information
 * Call back to book when PHA gets new information from member
1. Once booked, confirm:
 * Time and date of appointment
 * Location
 * Insurance
 * Visit length
 * Cancellation policy
1. Request new patient paperwork for member to complete before visit
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
