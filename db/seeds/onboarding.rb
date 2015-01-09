OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

o = OnboardingGroup.find_or_create_by_name(name: "Adam's users",
                                           premium: true,
                                           free_trial_days: 14,
                                           skip_credit_card: true)
ReferralCode.find_or_create_by_name(name: "Adam's users",
                                    code: 'adam',
                                    onboarding_group: o)

#Ensure that the Launch group is created, since we have a signup page for them
#This replaces the "inside" group
o = OnboardingGroup.find_or_create_by_name(name: 'Launch',
                                           premium: true,
                                           free_trial_days: 0,
                                           subscription_days: 365,
                                           skip_credit_card: true)
ReferralCode.find_or_create_by_name(name: 'Launch',
                                    code: 'launch',
                                    onboarding_group: o)

Metadata.upsert_attributes({mkey: 'nux_question_text'}, mvalue: 'You’re just two steps away from your own Personal Health Assistant. What would you like to focus on during your free trial?')

# Provider search --

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'find a new doctor or specialist', active: true, ordinal: 5)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you find a new doctor or specialist.

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) [Schedule a time to talk here](better://nb?cmd=scheduleCall), or message your PHA the reason for the visit (e.g. checkup, injury).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you find a new doctor or specialist. Send me a message with the reason for the visit (e.g. checkup, injury).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: provider search'}, text: MESSAGE.strip())

################################ Fighting a medical bill ####################################

NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fight a medical bill', active: true, ordinal: 6)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you sort out your medical bills.

To get started:

1) Take a photo of your insurance card (front & back) by tapping the camera. 
2) Take a photo of your medical bill.
3) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA details about the bill.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you sort out your medical bills. To get started, message me details about the bill and take a photo of the bill by tapping the camera.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: billing'}, text: MESSAGE.strip())

################################  Managing medical conditions ################################ 

NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'manage your medical conditions', active: true, ordinal: 9)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you start managing your medical conditions.

To get started:

1) [Add your medical conditions here](better://nb?cmd=showMedicalInformation).
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA any concerns.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you start managing your medical conditions. To get started, message me about any recent concerns and [add your medical conditions here](better://nb?cmd=showMedicalInformation).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical condition'}, text: MESSAGE.strip())

################################ Caring for a child ################################ 

NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'care for a child', active: true, ordinal: 3)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help support you and your family.

To get started:

1) [Add your child’s information here](better://nb?cmd=newProfile).
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA any questions or concerns.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help. To get started, tell me how I can support you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: childcare'}, text: MESSAGE.strip())

################################  Choosing new insurance ################################

NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choose new insurance', active: true, ordinal: 4)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you choose a new insurance plan.

To get started:

1) Add your [medical conditions here](better://nb?cmd=showMedicalInformation).
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA with what you’re looking for in a new insurance plan.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you choose a new insurance plan. To get started, message me with what you’re looking for in a new insurance plan.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: choosing insurance'}, text: MESSAGE.strip())

################################  Having a healthy pregnancy ################################

NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy pregnancy', phrase: 'have a healthy pregnancy', active: true, ordinal: 10)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you.  To get started, [schedule a time to talk](better://nb?cmd=scheduleCall) or send a message with your due date.

Tap below to learn about the services your PHA will provide during this exciting time as your family grows.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: pregnancy'}, {text: MESSAGE.strip(), content: Content.pregnancy})

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to support you. Tap below to learn what I can do for you during this exciting time as your family grows.

To get started, let me know when your due date is.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: pregnancy'}, {text: MESSAGE.strip(), content: Content.pregnancy})

# Caring for an aging parent --

NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'care for an aging parent', active: true, ordinal: 11)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help support you and your family.

To get started:

1) [Add your parent’s information here](better://nb?cmd=newProfile).
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA about your parent’s condition and your role in his/her care.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: eldercare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help support you and your family. To get started, message me about your parent’s condition and your role in their care.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: eldercare'}, text: MESSAGE.strip())

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

NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'lose some weight', active: true, ordinal: 8)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! *|pha_first_name|* will be available *|pha_next_available|* to help you. To get started, message your PHA about what motivates you to lose weight (e.g. a doctor’s recommendation, being healthier and more confident, having a fitness goal).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. Congratulations on taking your first step to a healthier you! To get started, tell me more about what motivates you to lose weight (e.g. a doctor’s recommendation, being healthier and more confident, having a fitness goal).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: weightloss'}, text: MESSAGE.strip())

########################## Trying to conceive ##############################

NuxAnswer.upsert_attributes({name: 'conception'}, text: 'Trying to conceive', phrase: 'start planning a family', active: true, ordinal: 7)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. *|pha_first_name|* will be available *|pha_next_available|* to help you start planning a family.

To get started:

1) Let your PHA know how long you’ve been trying to conceive.
2) [Schedule a time to talk](better://nb?cmd=scheduleCall), or message your PHA details about your birth control use.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: conception'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you start planning a family. To get started, tell me how long you’ve been trying to conceive.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: conception'}, text: MESSAGE.strip())

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
Welcome to Better, *|member_first_name|*! I’m here to help you with your health needs. To get started, tell me more about what health topics you’d like to work on together.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: something else'}, text: MESSAGE.strip())
