ServiceTemplate.upsert_attributes({name: "mayo pilot 2"},
                                  {title: "Mayo Pilot 2 - Stroke",
                                  description: "Stroke patients need extra attention in the first 30 days. Use the following tasks as message suggestions.",
                                  service_type: ServiceType.find_by_name('member onboarding'),
                                  time_estimate: 43200,
                                  timed_service: true})

PROVIDER_SEARCH_DESCRIPTION = <<-eof
**This service is assigned to PHA**

#Member Request
* **Member:**
* **Date of birth:**
* **Type of Doctor:**
* **Location (zip):**
* **Preferences (if any):**
* **Reason for visit:**
* **Insurance plan:**
* **Insurance website:**
* **Employer/Exchanges:**

#Specialist Notes

eof

PROVIDER_SEARCH_UPDATE = <<-eof
#User-Facing Service Deliverable Draft:

#Member update:

#PHA next steps:

#Specialist next steps:

eof

PROVIDER_SEARCH_REQUEST = <<-eof
Find a [provider type] near [zip code] who takes [insurance], [other preferences]
eof

ServiceTemplate.upsert_attributes({name: "provider search"},
                                  {title: "Find a [provider type]",
                                  description: PROVIDER_SEARCH_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('provider search'),
                                  time_estimate: 4500,
                                  service_request: PROVIDER_SEARCH_REQUEST,
                                  service_update: PROVIDER_SEARCH_UPDATE,
                                  user_facing: true})

APPOINTMENT_BOOKING_DESCRIPTION = <<-eof
**This service is assigned to PHA**

#Member Request
* **Member:**
* **Date of birth:**
* **Insurance plan:**
* **Provider:**
* **Address:**
* **Phone:**
* **Reason for visit:**
* **New Patient:** Yes/No
* **Specific dates/times that work better:**

#Specialist Notes

Date of call:
Who you spoke with:
Available times/Booked time:
Insurance still up-to-date: Yes/No
What to bring:
Special instructions to prepare:
eof

APPOINTMENT_BOOKING_UPDATE = <<-eof
#User-Facing Service Deliverable Draft:

Appointment details:
**[Day, Date at Time]**
Dr. [First Last]
Address:
Phone:
Other details: [what to bring, when to arrive]

#Member update:

#PHA next steps:

#Specialist next steps:

eof

APPOINTMENT_BOOKING_REQUEST = <<-eof
Book appointment with Dr. [First Last] for [reason] on [day/time]
eof

ServiceTemplate.upsert_attributes({name: "appointment booking"},
                                  {title: "Book appointment with Dr. [First Last]",
                                  description: APPOINTMENT_BOOKING_DESCRIPTION,
                                  service_type: ServiceType.find_by_name('appointment booking'),
                                  time_estimate: 150,
                                  user_facing: true,
                                  service_update: APPOINTMENT_BOOKING_UPDATE,
                                  service_request: APPOINTMENT_BOOKING_REQUEST})

CARE_COORDINATION_CALL_DESCRIPTION = <<-eof
**This service is assigned to PHA**

#Member Request
* **Member:**
* **Date of birth:**
* **Who to call:**
* **Phone number:**
* **Reason for call:**
* **Questions to ask:**
* **Possible next steps:**

#Specialist Notes
Date of call:
Who you spoke with:
Notes from call:

eof

CARE_COORDINATION_CALL_UPDATE = <<-eof
#User-Facing Service Deliverable Draft:

#Member update:

#PHA next steps:

#Specialist next steps:

eof

CARE_COORDINATION_CALL_REQUEST = <<-eof
Call [doctor/insurance/other] for [long reason]
eof

ServiceTemplate.upsert_attributes({name: "care coordination call"},
                                  {title: "Call [doctor/insurance/other] for [short reason]",
                                  description: CARE_COORDINATION_CALL_DESCRIPTION,
                                  service_update: CARE_COORDINATION_CALL_UPDATE,
                                  user_facing: true,
                                  service_request: CARE_COORDINATION_CALL_REQUEST,
                                  service_type: ServiceType.find_by_name('care coordination call'),
                                  time_estimate: 120})

PHA_AUTHORIZATION_DESCRIPTION = <<-eof
**This service is assigned to Specialist**

#Member Request
* **Member:**
* **Date of birth:**
* **Address:**
* **Legal name:**
* **Insurance member ID**
* **Insurance company:**
* **Insurance phone number:**
* **Purpose of authorization:** Care Coordination
* **Name of person to authorize:** Better and [PHA]

#Specialist Notes
Date of call:
Who you spoke with:
Notes from call:

* **Link to blank form:**
* **Date sent to insurance:**
* **Link to drafted form:**
* **Link to signed form:**

**Proofread the form by marking an “x” by each item that you check.**
**Proofreader name:**
**Date:**

  * Member name ( )
  * Date of birth  ( )
  * Address ( )
  * Better’s information ( )
  * Correct insurance company ( )
  * Insurance member ID ( )

eof

PHA_AUTHORIZATION_UPDATE = <<-eof
#User-Facing Service Deliverable Draft:

#Member update:

#PHA next steps:

#Specialist next steps:

eof

PHA_AUTHORIZATION_REQUEST = <<-eof
Authorize Better to speak on your behalf with [insurance company]. This usually takes insurance companies 30 days to process.
eof

ServiceTemplate.upsert_attributes({name: "pha authorization"},
                                  {title: "Authorize Better with [insurance company]",
                                  description: PHA_AUTHORIZATION_DESCRIPTION,
                                  service_update: PHA_AUTHORIZATION_UPDATE,
                                  user_facing: true,
                                  service_request: PHA_AUTHORIZATION_REQUEST,
                                  service_type: ServiceType.find_by_name('pha designation for authorization'),
                                  time_estimate: 43500}
)
RECORD_RECOVERY_DESCRIPTION = <<-eof
**This service is assigned to Specialist**

#Member Request
* **Member:**
* **Date of birth:**
* **Purpose of transfer:**
* **Type of records to release:**
* **Urgency:**

**Source Provider Info: **
Name:
Address:
Fax Number:
Phone number:

**Destination Provider Info:**
Name:
Address:
Fax Number:
Phone number:

#Specialist Notes
**Link to blank records release form:**
**Link to drafted form:**
**Link to signed form:**
Date records release form sent: [mm/dd/yy]

**Call notes - Source Provider:**
Date of call:
Who you spoke with:
Call notes:
Verified contact information: Yes/No
Form type: Generic/Specific for Provider
How the records will be sent:
Cost for records:
Turnaround time:

**Call notes - Destination Provider:**
Date of call:
Who you spoke with:
Call notes:
Verified contact information: Yes/No
Processing time:
Other:

**Proofread the form by marking an “x” by each item that you check.**
**Proofreader name:**
**Date:**

* Member name ()
* Date of birth  ()
* Address ()
* Source Provider info ()
* Destination Provider info ()
* Type of records ()
* Date requested ()

**Call notes - Form Received:**
Date of call:
Who you spoke with:
Call notes:
Records release form received: Yes/No

**Call notes - Records Transferred:**
Date of call:
Who you spoke with:
Call notes:
Records transferred: Yes/No
eof

RECORD_RECOVERY_UPDATE = <<-eof
#User-Facing Service Deliverable Draft:

#Member update:

#PHA next steps:

#Specialist next steps:

eof

RECORD_RECOVERY_REQUEST = <<-eof
Transfer medical records from [source provider] to [destination provider] for [reason]. This can take up to 30 days depending on the process of the medical records office.
eof

ServiceTemplate.upsert_attributes({name: "record recovery"},
                                  {title: "Transfer medical records to [destination provider]",
                                  description: RECORD_RECOVERY_DESCRIPTION,
                                  service_update: RECORD_RECOVERY_UPDATE,
                                  user_facing: true,
                                  service_request: RECORD_RECOVERY_REQUEST,
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

PRESCRIPTION_ORGANIZATION_REQUEST = <<-eof
Organize [member]'s prescriptions from [pharmacy name]
eof

ServiceTemplate.upsert_attributes({name: "prescription organization"},
                                  {title: "Prescription Organization",
                                   description: PRESCRIPTION_ORGANIZATION_DESCRIPTION,
                                   service_update: PRESCRIPTION_ORGANIZATION_UPDATE,
                                   user_facing: true,
                                   service_request: PRESCRIPTION_ORGANIZATION_REQUEST,
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
**This service is assigned to PHA**

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
#User-Facing Service Deliverable Draft:

Here are the measurements to show Dr. [First Last] at your next visit:

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
Support you in tracking your weight as part of meeting your nutrition goals over the next 6 months
eof

ServiceTemplate.upsert_attributes({name: "bmi management - 3 months"},
                                  {title: "Track your weight",
                                   description: BMI_MANAGEMENT_3_MONTHS_DESCRIPTION,
                                   service_update: BMI_MANAGEMENT_3_MONTHS_UPDATE,
                                   service_request: BMI_MANAGEMENT_3_MONTHS_REQUEST,
                                   user_facing: true,
                                   service_type: ServiceType.find_by_name('bmi management'),
                                   timed_service: true,
                                   time_estimate: 131760}
)

KINSIGHTS_RECORD_REQUEST = <<-eof
Collect and upload your child’s medical records to Kinsights from [Dr First Last]. This process can take up to 30 days depending on the office’s turn around time.
eof

KINSIGHTS_RECORD_DESCRIPTION = <<-eof
**This service is assigned to Specialist**

#Member Request
* **Member:**
* **Date of birth:**
* **Purpose of transfer:** Personal Use
* **Type of records to request:** All
* **Link to blank record request form:**
* **Link to complete record request form:**
* **Link to signed request form:**
* **Date request sent:**
* **Link to member’s Kinsights profile: **

**Records Source 1 - Collect from: **
Name:
Address:
Fax Number:
Office number:
Record release form:

**Destination - Send to: **
Name: Better
Address: 514 High Street Suite 4, Palo Alto, CA 94301
Fax Number:
HSA number’s Phone number:


#Specialist Notes
**Call notes - Source Provider:**
Date of call:
Who you spoke with:
Call notes:
Cost for records:
How the records will sent:
Turnaround time:
Type of form: Generic/Specific for Provider


**Records release form:**
Date records release form sent: [mm/dd/yy]
Date entered into Kinsights: [mm/dd/yy]
eof

KINSIGHTS_RECORD_UPDATE = <<-eof
#Specialist next steps:

Proofread the form by marking an “x” by each item that you check:
  - Member name ()
  - Date of birth  ()
  - Address ()
  - Correct Insurance company ()
  - Insurance number ()
  - Correct places to sign/initial ()
  - Date ()
eof

ServiceTemplate.upsert_attributes({name: "Kinsights Records"},
                                 {title: "Collect and upload your child’s medical records to Kinsights",
                                  description: KINSIGHTS_RECORD_DESCRIPTION,
                                  service_update: KINSIGHTS_RECORD_UPDATE,
                                  service_request: KINSIGHTS_RECORD_REQUEST,
                                  user_facing: true,
                                  service_type: ServiceType.find_by_name('record recovery'),
                                  time_estimate: 43200}
)

KINSIGHTS_ONBOARDING_DESCRIPTION = <<-eof
**This service is assigned to PHA**

**Profile for child built yet?:** Yes/No
**Asana task to create profile:**
**Kinsight info in profile notes?:** Yes/no
**Link to Kinsights Profile:**
  username: BetterPHA
  password: G3tB3tt3r!

#Check-in Message once a week

#Sign into Kinsights and update data
Each week review Better profile and Kinsight profile. Make additions to either Better profile or to Kinsight profile if discrepancies.

**Areas to update: **
* Height, Weight, BMI
* Any allergies
* Medical Conditions: Cystic Fibrosis
* Immunizations
* Any upcoming appointments
eof

KINSIGHTS_ONBOARDING_UPDATE = <<-eof
#Kinsights Profile updates
**[mm/dd/yy]:**
**[mm/dd/yy]:**
**[mm/dd/yy]:**
**[mm/dd/yy]:**

Add more notes/measurements below if needed

eof

ServiceTemplate.upsert_attributes({name: "PHA Intro + Check-Ins - Kinsights"},
                                 {title: "Kinsights Check-In",
                                  description: KINSIGHTS_ONBOARDING_DESCRIPTION,
                                  service_update: KINSIGHTS_ONBOARDING_UPDATE,
                                  user_facing: false,
                                  service_type: ServiceType.find_by_name('member onboarding'),
                                  timed_service: true,
                                  time_estimate: 121020}
)
