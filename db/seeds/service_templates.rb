ServiceTemplate.upsert_attributes({name: "mayo pilot 2"},
                                  {title: "Mayo Pilot 2 - Stroke",
                                  description: "Stroke patients need extra attention in the first 30 days. Use the following tasks as message suggestions. If you are already working with member you can abandon the message.",
                                  service_type: ServiceType.find_by_name('member onboarding'),
                                  time_estimate: 43200,
                                  timed_service: true})

PROVIDER_SEARCH_DESCRIPTION = <<-eof
#Member preference checklist
* **Type of Doctor:**
* **Location (zip):**
* **Preferences (if any):**
* **Reason for visit:**
* **Insurance plan:**
* **Insurance website:**
* **Employer/Exchanges:**

#PHA message to send (paste templated options here):
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
#Appointment preferences checklist
* **Member:**
* **Insurance plan:**
* **Provider:**
* **Address:**
* **Phone:**
* **Reason for visit:**
* **New Patient:** yes/no
* **Specific dates/times that work better:**

#PHA message to send (update template here):

Here are the details of your appointment:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number

Let me know if this works for you and I’ll add it to your calendar!
eof

ServiceTemplate.upsert_attributes({name: "appointment booking"},
                                  {title: "Appointment Booking",
                                  description: APPOINTMENT_BOOKING_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('appointment booking'),
                                  time_estimate: 150,
                                  user_facing: true,
                                  suggestion_description: "We can book an appointment with a doctor for you",
                                  suggestion_message: "I'm interested in scheduling an appointment"})

CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
Who to call:
Phone number:
For member:
Reason for call:
Questions to ask:
Possible next steps:

**Specialist Call Notes:**
Who you spoke with:
Notes from call:

---------------------------------------------------------

**Member update:**
1)

**PHA Next steps:**
1) Update member
2) (if needed)

**Specialist next steps:**
1) (if needed)
eof

ServiceTemplate.upsert_attributes({name: "care coordination call"},
                                  {title: "Care Coordination Call",
                                  description: CARE_COORDINATION_CALL_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('care coordination call'),
                                  time_estimate: 120})

PHA_AUTHORIZATION_DESCRIPTION = <<-eof
* **Member:**
* **Insurance company:**
* **Insurance phone number:**
* **Purpose of authorization:**
* **Name of person to authorize**
* **Link to signed form:**
* **Date sent to insurance:**
* **Member information** Birth dates, Address, insurance number, legal name
eof

ServiceTemplate.upsert_attributes({name: "pha authorization"},
                                  {title: "PHA Authorization",
                                  description: PHA_AUTHORIZATION_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('pha designation for authorization'),
                                  time_estimate: 43500}
)
RECORD_RECOVERY_DESCRIPTION = <<-eof
Member:
Purpose of transfer:
Type of records to request:
Urgency:
Link to record request form:
Date request sent:

**Records Source - Collect from: **
Name:
Address:
Fax Number:
Office number:
Record release form:

Call notes:
Office rep:

**Destination - Send to: **
Name:
Address:
Fax Number:
Office number:
Record request form (if needed):

Call notes
Office rep:
eof

ServiceTemplate.upsert_attributes({name: "record recovery"},
                                  {title: "Record Recovery",
                                  description: RECORD_RECOVERY_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('record recovery'),
                                  time_estimate: 11880}
)
