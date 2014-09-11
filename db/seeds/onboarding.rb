OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.upsert_attributes({mkey: 'nux_question_text'}, mvalue: 'You’re just two steps away from the experience of a Personal Health Assistant. What would you like to focus on during your free trial:')

# Provider search --

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'finding a new doctor or specialist', active: true, ordinal: 10)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you find a new doctor or specialist. 

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) [Enter your address here](better://nb?cmd=editProfile).
3) Message your PHA the reason for the visit (eg. checkup, injury), or [schedule a time to talk here](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you find a new doctor or specialist.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) [Enter your address here](better://nb?cmd=editProfile).
3) Message me the reason for the visit (eg. checkup, injury), or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: provider search'}, text: MESSAGE.strip())

# Fighting a medical bill --

NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fighting a medical bill', active: true, ordinal: 9)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you sort out your medical bills. 

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) Take a photo of your medical bill.
3) Message your PHA details about the bill or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you sort out your medical bills.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera.
2) Take a photo of your medical bill.
3) Message me details about the bill or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: billing'}, text: MESSAGE.strip())

# Managing medical conditions --

NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 8)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you start managing your medical conditions.

To get started:

1) [Add your medical conditions here](better://nb?cmd=showMedicalInformation).
2) Take a photo of your insurance card (front & back) by tapping the camera.
3) Message your PHA any concerns or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you start managing your medical conditions.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) [Add your medical conditions here](better://nb?cmd=showMedicalInformation).
2) Take a photo of your insurance card (front & back) by tapping the camera.
3) Message me about your medical conditions or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical condition'}, text: MESSAGE.strip())

# Caring for a child --

NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'caring for a child', active: true, ordinal: 7)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help support you and your family.

To get started:

1) [Add your child’s information here](better://nb?cmd=newProfile). 
2) Fill me in on any upcoming appointments.
3) Message your PHA any questions or concerns, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help support you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) [Add your child’s information here](better://nb?cmd=newProfile).
2) Fill me in about your family or any upcoming appointments. 
3) Message me about how I can support you and your family, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: childcare'}, text: MESSAGE.strip())

# Choosing new insurance --

NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choosing new insurance', active: true, ordinal: 6)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you choose a new insurance plan.

To get started:

1) Add your [medical conditions here](better://nb?cmd=showMedicalInformation). 
2) Add your [doctors here](better://nb?cmd=showCareTeam). 
3) Tell your PHA what you’re looking for in a new insurance plan or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you choose a new insurance plan.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) [Add your medical conditions to your profile here](better://nb?cmd=showMedicalInformation).
2) [Add your doctors here](better://nb?cmd=showCareTeam).
3) Tell me what you’re looking for in a new insurance plan or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: choosing insurance'}, text: MESSAGE.strip())

# Having a healthy baby --

NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy baby', phrase: 'having a healthy baby', active: true, ordinal: 5)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you during this exciting time as your family grows.

To get started:

1) Send a photo of your insurance card (front & back) by tapping the camera.
2) [Add your doctors here](better://nb?cmd=showCareTeam).
3) Message your PHA details about your pregnancy (e.g., due date) or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: pregnancy'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you during this exciting time as your family grows.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: pregnancy'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) Send a photo of your insurance card (front & back) by tapping the camera.
2) [Add your doctors here](better://nb?cmd=showCareTeam).
3) Message me details about your pregnancy (e.g., due date) or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: pregnancy'}, text: MESSAGE.strip())

# Caring for an aging parent --

NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'caring for an aging parent', active: true, ordinal: 4)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help support you and your family.

To get started:

1) [Add your parent’s information here](better://nb?cmd=newProfile).
2) Message your PHA about your parent’s condition and your role in their care.
3) [Schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: eldercare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help support you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: eldercare'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) [Add your parent’s information](better://nb?cmd=newProfile). 
2) Message me about your parent’s condition and your role in their care.
3) [Schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: eldercare'}, text: MESSAGE.strip())

# Medical question --

NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answering a medical question', active: true, ordinal: 3)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! We’re here to help with your medical question. You can talk to a Mayo Clinic nurse now by tapping the phone above. 

Otherwise, message *|pha_first_name|* your question and she’ll get back to you *|pha_next_available|*.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical question'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help. What is your medical question?
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical question'}, text: MESSAGE.strip())

# Losing some weight --

NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'losing some weight', active: true, ordinal: 2)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to create a plan for your weight loss goals. 

To get started:

1) Tell your PHA a little more about your weight loss goals.
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to create a plan for your weight loss goals.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started:

1) Tell me more about how I can support your weight loss goals.
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: weightloss'}, text: MESSAGE.strip())

# Something else --

NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'your health needs', active: true, ordinal: 1)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help with your health needs.

Here are a few simple things to get started:

1) Tell your PHA a little more about the health issue you’d like to work on together.
2) [Add any medical conditions to your profile](better://nb?cmd=showMedicalInformation).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: something else'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you with your health needs. 
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: something else'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Tell me more about what health topic you’d like to work on together.
2) [Add any medical conditions to your profile](better://nb?cmd=showMedicalInformation).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: something else'}, text: MESSAGE.strip())
