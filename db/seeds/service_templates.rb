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

PROCEDURE_CHECK_DESCRIPTION = <<-eof
**This service is assigned to Specialist**

#Member Request
* **Member:**
* **Date of birth:**
* **Doctor:**
* **Doctor Phone number:**
* **Insurance provider:**
* **Insurance plan:**
* **Insurance phone number:**
* **Auth on file?:** yes/no who?
* **Time set up with member for verbal auth:**
* **Procedure coverage inquiry:**

#Additional Information/Questions

#Specialist Notes

##Call with Provider
* Date of call:
* Who you spoke with:
* Insurance on file:
Questions:
* I would like to confirm that all of the services will be covered at the time of visit.  Have you performed a benefits check for the member?

**If yes**
- What are the coverage details?
	-Notes:
-Did you ask about the status of the member’s deductible?
	-Abandon next task (call insurance)
**If no**
-Are you willing to call {insurance} and check the members coverage?
**If yes**
-Great!  When do you expect this to be completed, so we can follow up?
**If no**
-May I have the service details?
		-CPT code/ other code:
		-Diagnosis (DX) code:
		-Do the provider and the facility bill separately? Yes/No
			-Provider tax ID:
			-Facility tax ID:

##Call with Insurance
* Date of call:
* Who you spoke with:
* Insurance effective date:
* Insurance termination date:
Questions:
* Is the member eligible for {service}?
* What type of coverage does the member have for {service}?
	-In network coverage:
	-Out of network coverage:
* Does {service} apply to the member’s deductible?
* What is the current state of the member’s deductible?
* Is there a prior authorization required for the service?
	-If yes, how is it obtained?
	-Notes:
* Is there a referral required for this service?
	-If yes, how is it obtained?
	-Notes:
* Are there any limitations for the service {office visit limit, max price, etc…}?
* Call reference number:

>#Service Update
>#PHA Next Steps:
>#Specialist Next Steps

eof

PROCEDURE_CHECK_UPDATE = <<-eof
#Service Request Update:

        {mm/dd}: We called Dr. {First Last}’s office to check your coverage for {procedure}.  The coverage details are below for you to view.


#Service Deliverable:
* Insurance provider:
* {Copayment / Percent coverage for service} with Dr. {First Last}:
* You’ve paid {$} towards your deductible of {deductible}
* **Final payment is based on contract with your insurance.**

#Member Message:

**If covered**
> Hi {member}, we checked if {insurance/provider} will cover your {service} with Dr. {First Last}, and good news!  {Insurance} will cover {amt % of cost / $amt} once you’ve met your deductible for this year. To date you’ve paid {amount paid} out of {total deductible}. Let us know if you have any questions.

Would you like to schedule the {procedure}?


 **If not covered**
> Hi {member}, we checked if {insurance} will cover your {service} with Dr. [First Last], and unfortunately {insurance} does not cover it.  Are you still interested in {service}?  If so, we can look for options that are affordable.
eof

PROCEDURE_CHECK_REQUEST = <<-eof
Check insurance coverage for {procedure} with Dr. {First Last}’s office. This can take up to a week depending on the availability of Dr. {First Last}’s billing department.
eof

ServiceTemplate.upsert_attributes({name: "Check Member’s Procedure Coverage with Provider"},
                                  {title: "Check Insurance Coverage for {procedure} with Dr. {First Last}",
                                   description: PROCEDURE_CHECK_DESCRIPTION,
                                   service_update: PROCEDURE_CHECK_UPDATE,
                                   user_facing: true,
                                   service_request: PROCEDURE_CHECK_REQUEST,
                                   service_type: ServiceType.find_by_name('eligibility check'),
                                   time_estimate: 180}
)

ELIGIBILITY_BENEFITS_CHECK_DESCRIPTION = <<-eof
**This service is assigned to {PHA}**

#Member Request
* **Member:**
* **Date of birth:**
* **Insurance provider:**
* **Insurance plan:**
* **Insurance phone number:**
* **Auth on file?:** yes/no who?
* **Time set up with member for verbal auth:**
* **Eligibility/Benefits inquiry:**

#Additional Information/Questions

#Specialist Notes

* Date of call:
* Who you spoke with:
* Insurance effective date:
* Insurance termination date:

**Inquiry based on member request:**

* Is the member eligible for {service}?
* What type of coverage does the member have for {service}?
	-In network coverage:
	-Out of network coverage:
* Does [service] apply to the member’s deductible?
* What is the current state of the member’s deductible?
* Is there a prior authorization required for the service?
	-If yes, how is it obtained?
	-Notes:
* Is there a referral required for this service?
	-If yes, how is it obtained?
	-Notes:
* Are there any limitations for the service {office visit limit, max price, etc…}?
* Call reference number:

#Service Update
#PHA Next Steps:
1.
2.
#Specialist Next Steps

eof

ELIGIBILITY_BENEFITS_CHECK_UPDATE = <<-eof
#Service Request Update:

        {mm/dd}: We called {Insurance} to check your coverage for {member inquiry}.  The coverage details are below for you to view.

#Service Deliverable:
* Insurance provider:
* Percent coverage for {service} with an in-network provider:
* Percent coverage for {service} with an out-of-network provider:
* You’ve paid {$} towards your deductible of {deductible}
* A referral for this service is [not] required

#Member Message:
**If covered**
> Hi {member} we checked if you are eligible for {service}, and good news!  Your insurance quoted that you are eligible for {service}.  {Insurance} will cover { % / $ amount} of the cost up to {benefit limitation}.


> Even though it is covered, we also have to understand how it fits in with your deductible. To date this year, you’ve paid {$} out of {deductible}. This means that you’ll have to pay the full bill until you’ve paid {$} more. OR Since you’ve met your deductible insurance will kick in right away and insurance will cover {%}.


> It is important to follow the instructions of the insurance company and even then, it is important to remember that this is just a quote.

 **If not covered**
> Hi {member}, we checked if you are eligible for {service}, and unfortunately {insurance} does not cover it.  Are you still interested in {service}?  If so, we can look for options that are affordable.

eof

ELIGIBILITY_BENEFITS_CHECK_REQUEST = <<-eof
Check to see if {specific member inquiry} is covered by {insurance}
eof

ServiceTemplate.upsert_attributes({name: "Check Member’s Eligibility/Benefits with Insurance"},
                                  {title: "Check insurance coverage for {specific member inquiry}",
                                   description: ELIGIBILITY_BENEFITS_CHECK_DESCRIPTION,
                                   service_update: ELIGIBILITY_BENEFITS_CHECK_UPDATE,
                                   user_facing: true,
                                   service_request: ELIGIBILITY_BENEFITS_CHECK_REQUEST,
                                   service_type: ServiceType.find_by_name('eligibility check'),
                                   time_estimate: 120}
)

DENTIST_APPOINTMENT_DESCRIPTION = <<-eof
**This service is assigned to {PHA}**

#Member Request
* **Member:**
* **Date of birth:**
* **Dental insurance plan:**
* **Dentist:**
* **Address:**
* **Phone:**
* **Reason for visit:** cleaning & exam /follow-up/ procedure
* **New Patient:** Yes/No
* **Specific dates/times that work better:**

#Additional Information/Questions

#Specialist Notes
* Date of call:
* Who you spoke with:
* Available times/Booked time:
* Insurance on file still up-to-date: Yes/No
* Benefits/coverage check prior to member’s service: Yes/No
* Dentist office will update member with coverage check and price estimate: Yes/No
* Can you if they are due for another cleaning? Has it been six months? Yes/No
* Cancellation policy: Yes/No
* New patient paperwork:
* Length of visit:
* What to bring:
* Special instructions to prepare:


#Service Update
#PHA Next Steps:
1.
2.
#Specialist Next Steps

eof

DENTIST_APPOINTMENT_UPDATE = <<-eof
#Service Deliverable:

After Specialist Review:

#Member Message:

Hi [member], we’ve reviewed your medical bill and we working on gathering more information.  We will be calling your {insurance, provider} to get to the bottom of this!

We might need to get your verbal authorization over the phone to get this information. Do you have a 30-minute window of time you are available to answer our phone call tomorrow or later this week?


After Further Investigation

#Member update for simple bill breakdown:

Hi {member}, we’ve reviewed your medical bill and called [insurance, provider] to confirm the amount you owe and accuracy. Here is the breakdown:

{Provider & Date of Visit}
**Total billed:**
**Contracted rate**
**{Co-payment Co-insurance}**
** Insurance paid**
** Your Total**

You'll notice that insurance {did or did not pay}, this is because you {have not or have} met your deductible for {year}. Your deductible is [ Deductible $] and to date you’ve paid [$amount toward deductible]. *

If not met deductible  -
{For future visits and bill, you'll continue to pay the full contracted rate until you meet your deductible. *}

If have met deductible
{You’ve met the deductible so insurance will pay the majority of the bill but you’ll be responsible for your copayment and coinsurance. }


**Here is how to pay: **
	[Add in instructions]
eof

DENTIST_APPOINTMENT_REQUEST = <<-eof
Book appointment with Dr. {First Last} for {cleaning and exam /follow-up/ procedure} on {day/time}
eof

ServiceTemplate.upsert_attributes({name: "Book Dentist Appointment"},
                                  {title: "Book dentist appointment with Dr. {First Last}",
                                   description: DENTIST_APPOINTMENT_DESCRIPTION,
                                   service_update: DENTIST_APPOINTMENT_UPDATE,
                                   user_facing: true,
                                   service_request: DENTIST_APPOINTMENT_REQUEST,
                                   service_type: ServiceType.find_by_name('appointment booking'),
                                   time_estimate: 240}
)

REVIEW_MEDICAL_BILL_DESCRIPTION = <<-eof
**This service is assigned to PHA**

#Member Request
* **Member:**
* **Date of birth:**
* **Question about bill:**
* **Link to medical bill:**
* **Date of service:**

* **Insurance at time at DOS:**
* **Insurance card in profile:** yes/no
* **Auth on file:** yes/no
* **Insurance phone number:**
* **Insurance website username:**
* **Insurance website password:**

* **Provider:**
* **Provider phone number:**
* **Account #:**


#Additional Information/Questions:
#Specialist Notes

##Review of Medical Bill
-Date of service:
-Provider:
-CPT code (or procedure code):
-Total billed amount
-Allowed Amount
-Member owes:
-Notes about bill:
-Hypothesis:

-Next Steps:



##Call with Insurance (delete if not necessary)
-Date of call:
-Who you spoke with:
-Insurance effective date:
-Insurance termination date:
-Notes:

-Call reference number:


Call with Provider (delete if not necessary)
-Date of call:
-Who you spoke with:
-Insurance on file:
-Notes:


Additional Information  Search (delete if not necessary)
	-Link to EOB in member’s file
- Notes:

#PHA next steps:

#Specialist next steps:

eof

REVIEW_MEDICAL_BILL_UPDATE = <<-eof
#Service Request Update:

        {mm/dd}: We booked {you/member name} a dentist appointment with Dr. {First Last}. The appointment details are below for you to view.

#Service Deliverable:
{Day, Date, and Time}
Dr. {First Last}
Address:
Phone:
Other details: {what to bring, when to arrive}
Cancellation fee:
Answers to your questions:

#Member Message:

        We’ve booked the dentist appointment you requested and sent you a calendar reminder. Let us know if you need to make any changes.

**If dentist verifies coverage**

        We’ve asked your dentist to check your insurance coverage. Book appointment with Dr. {First Last} for {cleaning and exam /follow-up/ procedure} on {day/time}They may be contacting you with more information.

**If dentist does not verify coverage**

        We asked your dentist to verify your insurance coverage, but they were unable to do so. If you’d like, we can find another dentist to ensure that you are covered.

eof

REVIEW_MEDICAL_BILL_REQUEST = <<-eof
Investigate {member’s} medical bill from {provider} for  {reason for investigation}. We’ll take a couple of days to review with our medical billing specialists and update you with our next steps.
eof

ServiceTemplate.upsert_attributes({name: "Review medical bill"},
                                  {title: "Medical Bill Investigation",
                                   description: REVIEW_MEDICAL_BILL_DESCRIPTION,
                                   service_update: REVIEW_MEDICAL_BILL_UPDATE,
                                   user_facing: true,
                                   service_request: REVIEW_MEDICAL_BILL_REQUEST,
                                   service_type: ServiceType.find_by_name('medical bill investigation'),
                                   time_estimate: 2880}
)
