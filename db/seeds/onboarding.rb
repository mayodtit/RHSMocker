OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.upsert_attributes({mkey: 'nux_question_text'}, mvalue: 'You’re just two steps away from your own Personal Health Assistant. What would you like to focus on during your free trial?')

# Provider search --

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'find a new doctor or specialist', active: true, ordinal: 5)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you find a new doctor or specialist. 

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) [Schedule a time to talk here](better://nb?cmd=scheduleCall), or message *|pha_first_name|* the reason for the visit (e.g. checkup, injury).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you find a new doctor or specialist.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Let's get started! Message with the reason for the visit (e.g. checkup, injury)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: provider search'}, text: MESSAGE.strip())

################################ Fighting a medical bill ####################################

NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fight a medical bill', active: true, ordinal: 6)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you sort out your medical bills. 

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) Take a photo of your medical bill.
3) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message *|pha_first_name|* PHA details about the bill.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you sort out your medical bills.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Let's get started! Message me details about the bill and take a photo of the bill by tapping the camera.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: billing'}, text: MESSAGE.strip())

################################  Managing medical conditions ################################ 

NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'manage your medical conditions', active: true, ordinal: 8)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you manage your medical conditions.

To get started:

1) [Add your medical conditions here](better://nb?cmd=showMedicalInformation).
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message *|pha_first_name|* below.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you manage your medical conditions.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started, message me about any recent concerns and [add your medical conditions] to your profile(better://nb?cmd=showMedicalInformation). 
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical condition'}, text: MESSAGE.strip())

################################ Caring for a child ################################ 

NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'care for a child', active: true, ordinal: 3)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help support you and your family.

To get started:

1) [Add your child’s information here](better://nb?cmd=newProfile). 
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message *|pha_first_name|* any questions or concerns.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help support you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
To get started, tell me a little about your family and your health goals. 
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: childcare'}, text: MESSAGE.strip())

################################  Choosing new insurance ################################

NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choose new insurance', active: true, ordinal: 4)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you choose a new insurance plan.

To get started:

1) Add your [medical conditions here](better://nb?cmd=showMedicalInformation) so we can be sure to find you insurance options that cover your needs. 
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message *|pha_first_name|* with what you’re looking for in a new insurance plan.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you choose a new insurance plan.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Let's get started. Can you message me with what you’re looking for in a new insurance plan, and if you currently have insurance? 
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: choosing insurance'}, text: MESSAGE.strip())

################################  Having a healthy baby ################################ 

NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy baby', phrase: 'have a healthy baby', active: true, ordinal: 2)

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

NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'care for an aging parent', active: true, ordinal: 10)

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

NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answer a medical question', active: true, ordinal: 2)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! We’re here to help with your medical question. You can talk to a Mayo Clinic nurse now by tapping the phone above. 

Otherwise, message *|pha_first_name|* your question and she’ll get back to you *|pha_next_available|*.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical question'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help. What is your medical question?
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical question'}, text: MESSAGE.strip())

########################## Losing some weight ##############################

NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'lose some weight', active: true, ordinal: 7)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to create a plan for your weight loss goals. 

To get started:

1) Tell *|pha_first_name|* a little more about your weight loss goals.  
2) If you have any current medical conditions we should know about, please [add them to your Profile](better://nb?cmd=showMedicalInformation).

eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to create a plan for your weight loss goals.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Tell me more about your current weight, and your goals for weight loss. Go ahead and send me a message, so we can get started. 
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: weightloss'}, text: MESSAGE.strip())

# Something else --

NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'with your health needs', active: true, ordinal: 1)

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
