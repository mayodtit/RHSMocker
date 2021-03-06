# Description Templates --
MEDICAL_BILL_INVESTIGATION_DESCRIPTION_TEMPLATE = <<-eof
What member is looking to find out?
Super bill:
Claims Form:
Image links to bills in question:
Call Notes to doctor's office:
Call Notes to insurance:
eof

INSURANCE_SEARCH_BUYING_DESCRIPTION_TEMPLATE = <<-eof
Current plan? When did it end and why, current premium
Individual vs Family
Employer vs exchange (if family, confirm no one in family is eligible for insurance through employer)
Zip code
Birthdate (of all family members, if family)
Gender (of all family members, if family)
Doctors: yes/no
Care visits
If high, Medical conditions
Medications: yes/no (list if they have them)
Smoke: yes/no
student: yes/no
Household income (if exchanges):
Plan preferences (hmo vs ppo)
Dental and vision
eof

APPOINTMENT_BOOKING_DESCRIPTION_TEMPLATE = <<-eof
For which person:
Insurance plan:
Provider:
Address:
Phone number:
Reason for visit:
Specific dates/times that work better:

________________________________

Call notes:

Who you spoke with:
Available times/Booked time:
Insurance still up-to-date:
What to bring:
Special instructions to prepare:

________________________

Update message for PHA to send:

Here are the details of your appointment:

**Day, Date at Time**
Dr. First Last
Address: ([map](map link))
Phone: Phone number

Let me know if this works for you and I’ll add it to your calendar!
eof

PROVIDER_SEARCH_DESCRIPTION_TEMPLATE = <<-eof
Description:
Doctor type
Reason for visit
Zip code
Gender preference
Insurance company and full name of plan:
Insurance website from back of card:
Insurance through employer or exchange
Specific Appointment needs?
Other important information
eof

RECORD_RECOVERY_DESCRIPTION_TEMPLATE = <<-eof
For which family member?
For what use:
Type of records to request:
Urgency:

**Records from: **
Name:
Address:
Fax Number
Office number

**Send to: **
Name:
Address:
Fax Number
Office number
Call notes:
eof

WELCOME_CALL_DESCRIPTION_TEMPLATE = <<-eof
"Hi <member>, I'm really excited to work with you! To confirm, is 000-000-0000 a good number go call?"
eof

PHA_INTRODUCTION_DESCRIPTION_TEMPLATE = <<-eof
Thanks for signing up for Better. I'm here to support you with:      . I'll get started and you can expect an update by_______. In the meantime, feel free to message back in with questions. Our team will be quick to respond and I'll always follow up.
Tasks 30 days for PHA to assign:
Complete profile task
3 Friday check-in tasks
Offer Insurance Review Service
Perform Preventive Care Assessment
Offer Creating Care Team Service
eof

PHA_INTRODUCTION_JACKSONVILLE_DESCRIPTION_TEMPLATE = <<-eof
Send intro message to member

M1: Hi [Patient], my name is [PHA name] and I'll be your Personal Health Assistant. I'm here to help you with your transition out of the hospital. I am working with your Mayo Clinic care team to transfer over your discharge plan. I will message you in the app as soon as I have it here so we can go over it together.
eof

REVIEW_MEMBER_MEALS_DESCRIPTION_TEMPLATE = <<eof
member's goal:
dates to review:
eof

REVIEW_DISCHARGE_PAPERS_DESCRIPTION_TEMPLATE = <<eof
Who reviewed?
Who double checked?
eof

# Service Types -
ServiceType.find_or_create_by_name(name: 'other', bucket: 'other')

# Insurance --
ServiceType.find_or_create_by_name(name: 'insurance review', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'insurance call', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'claims', bucket: 'insurance')
ServiceType.upsert_attributes!({name: 'medical bill investigation'}, {bucket: 'insurance', description_template: MEDICAL_BILL_INVESTIGATION_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'cost estimation', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'deductible/FSA/HSA status assessment', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'eligibility check', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'grievances', bucket: 'insurance')
ServiceType.upsert_attributes!({name: 'insurance plan - search'}, {bucket: 'insurance', description_template: INSURANCE_SEARCH_BUYING_DESCRIPTION_TEMPLATE})
ServiceType.upsert_attributes!({name: 'insurance plan - buying/applying'}, {bucket: 'insurance', description_template: INSURANCE_SEARCH_BUYING_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'PHA designation for authorization', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'pre/prior authorization for service', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'temporary insurance', bucket: 'insurance')
ServiceType.find_or_create_by_name(name: 'other insurance', bucket: 'insurance')

# Care Coordination --
ServiceType.upsert_attributes!({name: 'appointment booking'}, {bucket: 'care coordination', description_template: APPOINTMENT_BOOKING_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'appointment preparation', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'facility search (hospital, assisted living, etc)', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'specialist/2nd opinion', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'medical/clinical research', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'natural disaster preparedness', bucket: 'care coordination')
ServiceType.upsert_attributes!({name: 'provider search'}, {bucket: 'care coordination', description_template: PROVIDER_SEARCH_DESCRIPTION_TEMPLATE})
ServiceType.upsert_attributes!({name: 'record recovery'}, {bucket: 'care coordination', description_template: RECORD_RECOVERY_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'prescription management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'prescription organization', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'symptom management', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'other care coordination', bucket: 'care coordination')
ServiceType.upsert_attributes!({name: 'preventive care reminders'}, bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'urgent care and emergency room', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'prevention screenings', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'assemble care team', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'care coordination call', bucket: 'care coordination')
ServiceType.find_or_create_by_name(name: 'review discharge papers', bucket: 'care coordination', description_template: REVIEW_DISCHARGE_PAPERS_DESCRIPTION_TEMPLATE)
ServiceType.find_or_create_by_name(name: 'bmi management', bucket: 'care coordination')

# Engagement --
ServiceType.upsert_attributes!({name: 'welcome call'}, {bucket: 'engagement', description_template: WELCOME_CALL_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'check-in call', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'collect member due date', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'outbound call', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'member onboarding', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'member offboarding', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'send pregnancy content card', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 're-engagement', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'relevant content', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'themed months questions and content', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'offer insurance review service', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'offer care team creation service', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'complete profile', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'introduction task', bucket: 'engagement')
ServiceType.upsert_attributes!({name: 'PHA Introduction'}, {bucket: 'engagement', description_template: PHA_INTRODUCTION_DESCRIPTION_TEMPLATE})
ServiceType.upsert_attributes!({name: 'PHA Introduction - Jacksonville'}, {bucket: 'engagement', description_template: PHA_INTRODUCTION_JACKSONVILLE_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'check-in message', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'service and message planning', bucket: 'engagement')
ServiceType.upsert_attributes!({name: 'review member meals'}, {bucket: 'engagement', description_template: REVIEW_MEMBER_MEALS_DESCRIPTION_TEMPLATE})
ServiceType.find_or_create_by_name(name: 'process insurance card', bucket: 'engagement')
ServiceType.find_or_create_by_name(name: 'other engagement', bucket: 'engagement')

# Wellness --
ServiceType.find_or_create_by_name(name: 'exercise assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'nutrition assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'sleep assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'stress assessment and plan', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'wellness research', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'send articles or tips', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'send recipes', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'send member meal feedback', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'send member travel planning', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'other wellness', bucket: 'wellness')
# Wellness -- weight mgmnt
ServiceType.find_or_create_by_name(name: 'celebration video', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'set goal', bucket: 'wellness')
ServiceType.find_or_create_by_name(name: 'member completes goal', bucket: 'wellness')
