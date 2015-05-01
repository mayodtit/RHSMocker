ServiceTemplate.upsert_attributes({name: "mayo pilot 2"},
                                  {title: "Mayo Pilot 2 - Stroke",
                                  description: "Stroke patients need extra attention in the first 30 days. Use the following tasks as message suggestions. If you are already working with member you can abandon the message.",
                                  service_type: ServiceType.find_by_name('member onboarding'),
                                  time_estimate: 43200,
                                  timed_service: true})

PROVIDER_SEARCH_DESCRIPTION = <<-eof
**Service assigned to PHA**

#Member Request
* **Type of Doctor:**
* **Location (zip):**
* **Preferences (if any):**
* **Reason for visit:**
* **Insurance plan:**
* **Insurance website:**
* **Employer/Exchanges:**

#Specialist notes

eof

ServiceTemplate.upsert_attributes({name: "provider search"},
                                  {title: "Provider Search",
                                  description: PROVIDER_SEARCH_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('provider search'),
                                  time_estimate: 4500,
                                  user_facing: true,
                                  suggestion_description: "We can find you a doctor near you",
                                  suggestion_message: "I'd like to find a doctor"})

APPOINTMENT_BOOKING_DESCRIPTION = <<-eof
**This Service Is Assigned to PHA**

#Member Request
* **Member:**
* **Insurance plan:**
* **Provider:**
* **Address:**
* **Phone:**
* **Reason for visit:**
* **New Patient:** yes/no
* **Specific dates/times that work better:**

#Specialist notes

Who you spoke with:
Date of call:
Available times/Booked time:
Insurance still up-to-date:
What to bring:
Special instructions to prepare:
eof

APPOINTMENT_BOOKING_UPDATE = <<-eof
We’ve found you an appointment with Dr. [First Last]. Here are the details:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number
-Other details (what to bring, when to arrive)

Let me know if this works for you and I’ll add it to your calendar!
eof

ServiceTemplate.upsert_attributes({name: "appointment booking"},
                                  {title: "Appointment Booking",
                                  description: APPOINTMENT_BOOKING_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('appointment booking'),
                                  time_estimate: 150,
                                  user_facing: true,
                                  service_update: APPOINTMENT_BOOKING_UPDATE,
                                  suggestion_description: "We can book an appointment with a doctor for you",
                                  suggestion_message: "I'm interested in scheduling an appointment"})

CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
**This Service Is Assigned to PHA**

#Member Request
* **Who to call:**
* **Phone number:**
* **For member:**
* **Reason for call:**
* **Questions to ask:**
* **Possible next steps:**

#Specialist notes
Who you spoke with:
Date/time of call:
Notes from call:
eof

CARE_COORDINATION_CALL_UPDATE = <<-eof
**Member update:**
1.

**PHA Next steps:**
1. Update member
2. (if needed)

**Specialist next steps:**
1. (if needed)
eof

ServiceTemplate.upsert_attributes({name: "care coordination call"},
                                  {title: "Care Coordination Call",
                                  description: CARE_COORDINATION_CALL_DESCRIPTION,
                                  service_update: CARE_COORDINATION_CALL_UPDATE,
                                  service_type: ServiceType.find_by_name('care coordination call'),
                                  time_estimate: 120})

PHA_AUTHORIZATION_DESCRIPTION = <<-eof
**This Service Is Assigned to Specialist**

#Member Request
* **Member:**
* **Insurance company:**
* **Insurance phone number:**
* **Purpose of authorization:**
* **Name of person to authorize**
* **Link to signed form:**
* **Date sent to insurance:*
* **Member information:** Birth dates, Address, insurance number, legal name

#Specialist notes
eof

ServiceTemplate.upsert_attributes({name: "pha authorization"},
                                  {title: "PHA Authorization",
                                  description: PHA_AUTHORIZATION_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('pha designation for authorization'),
                                  time_estimate: 43500}
)
RECORD_RECOVERY_DESCRIPTION = <<-eof
**Service assigned to Specialist**

#Member Request
* **Member:**
* **Purpose of transfer::**
* **Type of records to request::**
* **Urgency::**
* **Link to record request form::**
* **Date request sent::**

**Records Source - Collect from: **
Name:
Address:
Fax Number:
Office number:
Record release form:

**Destination - Send to: **
Name:
Address:
Fax Number:
Office number:
Record request form (if needed):

#Specialist notes
Call notes:
Office representative:
Verified contact information: yes/no
Form: website/faxed to better/email
Cost:
Turnaround time:
Other:
eof

ServiceTemplate.upsert_attributes({name: "record recovery"},
                                  {title: "Record Recovery",
                                  description: RECORD_RECOVERY_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('record recovery'),
                                  time_estimate: 11880}
)

PRESCRIPTION_ORGANIZATION_DESCRIPTION = <<-eof
**Service assigned to PHA**

**Pharmacy 1**
-Phone
-Address
-Online portal login
-Online portal password
**Pharmacy 2 (if applicable)**
**Available time for verbal auth:**
**Link to list of medications from pharmacy:**
**Link to Prescription Information Spreadsheet:**
eof

PRESCRIPTION_ORGANIZATION_UPDATE = <<-eof
* Next services that come out it
* Written auth needed
* Manual / auto refill services
eof

ServiceTemplate.upsert_attributes({name: "prescription organization"},
                                  {title: "Prescription Organization",
                                   description: PRESCRIPTION_ORGANIZATION_DESCRIPTION,
                                   service_update: PRESCRIPTION_ORGANIZATION_UPDATE,
                                   service_type: ServiceType.find_by_name('prescription management'),
                                   time_estimate: 240}
)

APPOINTMENT_PREPARATION_CF_DESCRIPTION = <<-eof
**This Service is assigned to PHA**

#Appointment Information
* **Member:**
* **Appointment Date/Time:**
* **Provider:**
* **Address:**
* **Phone:**
* **Reason for visit:**
* **New Patient:** yes/no
eof

APPOINTMENT_PREPARATION_CF_UPDATE = <<-eof
#PHA notes before appointment
* **Member confirmed 1 month out: yes/no**
* **Member confirmed 1 week out: yes/no**
* **Transportation:**
* **New symptoms:**
* **Medication questions:**
* **Nutrition questions:**
* **Current BMI:**
* **All BMI measurements since last visit:**

#PHA notes after appointment
* **Notes from Appointment:**
* **Next appointment date/time:**
eof

ServiceTemplate.upsert_attributes({name: "appointment preparation - cf"},
                                  {title: "Appointment Preparation - CF",
                                   description: APPOINTMENT_PREPARATION_CF_DESCRIPTION,
                                   service_update: APPOINTMENT_PREPARATION_CF_UPDATE,
                                   service_type: ServiceType.find_by_name('appointment preparation'),
                                   time_estimate: 240}
)
BMI_MANAGEMENT_3_MONTHS_DESCRIPTION = <<-eof
**This Service is Assigned to PHA**

#Weight notes
* **When to weigh:**
* **Weigh-in routine:**
* **Starting BMI:**
* **Starting date:**
* **Weight goals:**

#Member request
* **Member name:**
* **Doctor name:**
* **Doctor phone:**
* **Next CF appointment:**



#Previous BMI notes
* Notes/trends from the last 3 months of measuring (barriers to weighing, changes to routine, etc)

#Previous BMI measurements
**Paste any important past BMI measurements and dates here**
eof

BMI_MANAGEMENT_3_MONTHS_UPDATE = <<-eof
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**
* **BMI and date:**

Add more notes/measurements below if needed

eof

BMI_MANAGEMENT_3_MONTHS_REQUEST = <<-eof
Support [member/you] in tracking your BMI to prepare for your appointment with Dr. [doctor name]
eof

ServiceTemplate.upsert_attributes({name: "bmi management - 3 months"},
                                  {title: "BMI tracking",
                                   description: BMI_MANAGEMENT_3_MONTHS_DESCRIPTION,
                                   service_update: BMI_MANAGEMENT_3_MONTHS_UPDATE,
                                   service_request: BMI_MANAGEMENT_3_MONTHS_REQUEST,
                                   user_facing: true,
                                   service_type: ServiceType.find_by_name('bmi management'),
                                   timed_service: true,
                                   time_estimate: 131760
)
