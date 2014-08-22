OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.find_or_create_by_mkey(mkey: 'nux_question_text', mvalue: 'You’re just two steps away from the experience of a Personal Health Assistant. What would you like to focus on during your free trial:')

# Provider search --

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'finding a new doctor or specialist', active: true, ordinal: 10)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. I’ll be available *|pha_next_available|* to help you find a new doctor or specialist.

Here are a few simple things to get started:

1) Send a photo of your health insurance card (front and back) by tapping the camera button
2) So I can find one near you, [enter your address](better://nb?cmd=openPage&page=profile)
3) Message me the type of doctor or the reason for the visit (for example, annual checkup), or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: provider search'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Send a photo of your health insurance card (front and back) by tapping the camera button
2) So I can find one near you, [enter your address](better://nb?cmd=openPage&page=profile)
3) Message me the type of doctor or the reason for the visit (for example, annual checkup), or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: provider search'}, text: MESSAGE.strip())

# Fighting a medical bill --

NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fighting a medical bill', active: true, ordinal: 9)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. I’ll be available *|pha_next_available|* to start looking into your medical bills.

Here are a few simple things to get started:

1) Send a photo of your health insurance card (front and back) by tapping the camera button
2) Send a photo of each page of the medical bill
3) [Add the doctor](better://nb?cmd=showCareTeam) who sent you the bill
4) Message details about the bill, or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: billing'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Send a photo of your health insurance card (front and back) by tapping the camera button
2) Send a photo of your medical bill
3) [Add the doctor](better://nb?cmd=showCareTeam)  who sent you the bill
4) Message details about the bill, or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: billing'}, text: MESSAGE.strip())

# Managing medical conditions --

NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 8)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. I’ll be available *|pha_next_available|* to help you start managing your medical conditions.

Here are a few simple things to get started:

1) [Add your medical conditions to your health profile](better://nb?cmd=showMedicalInformation)
2) Send a photo of your health insurance card (front and back) by tapping the camera button
3) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
4) Message me any questions or concerns, or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical condition'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Add your medical conditions to your [health profile](better://nb?cmd=showMedicalInformation)
2) Send a photo of your health insurance card (front and back) by tapping the camera button
3) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
4) Message me any questions or concerns, or [schedule a time to talk](better://nb?cmd=scheduleCall)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical condition'}, text: MESSAGE.strip())

# Caring for a child --

NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'caring for a child', active: true, ordinal: 7)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’ll be available *|pha_next_available|* to help support you and your family.

Here are a few simple things I need to get started:

1) Add your child’s information [here](better://nb?cmd=showProfile)
2) Fill me on any upcoming procedures or appointments.
3) Message me any questions or concerns, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: childcare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Add your child’s information [here](better://nb?cmd=showProfile)
2) Fill me in about your family or any upcoming procedures or appointments.
3) Message me any questions or concerns, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: childcare'}, text: MESSAGE.strip())

# Choosing new insurance --

NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choosing new insurance', active: true, ordinal: 6)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’ll be available *|pha_next_available|* to help you choose new health insurance

Here are a few simple things I need to get started:

1) Add your medical conditions to your [health profile](better://nb?cmd=showMedicalInformation)
2) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
3) Message me a little bit about your situation or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: choosing insurance'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) [Add your medical conditions to your health profile](better://nb?cmd=showMedicalInformation)
2) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
3) Message me a little bit about your situation or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: choosing insurance'}, text: MESSAGE.strip())

# Having a healthy baby --

NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy baby', phrase: 'having a healthy baby', active: true, ordinal: 5)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’ll be available *|pha_next_available|* to help you during this exciting time as your family grows.

Here are a few simple things I need to get started:

1) Add your medical conditions to your [health profile](better://nb?cmd=showMedicalInformation)
2) Send a photo of your health insurance card (front and back) by tapping the camera button
3) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
4) Message me more details about your pregnancy like your due date or complications you are experiencing, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: pregnancy'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you and your new family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: pregnancy'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) [Add your medical conditions to your health profile](better://nb?cmd=showMedicalInformation)
2) Send a photo of your health insurance card (front and back) by tapping the camera button
3) [Add your doctors](better://nb?cmd=showCareTeam) to your Care Team
4) Message me on details about your pregnancy like your due date or complications you are experiencing, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: pregnancy'}, text: MESSAGE.strip())

# Caring for an aging parent --

NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'caring for an aging parent', active: true, ordinal: 4)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’ll be available *|pha_next_available|* to help support you and your family.

Here are a few simple things I need to get started:

1) Add your parent’s information [here](better://nb?cmd=showProfile)
2) Message me about your parent’s conditions or [schedule a time to talk](better://nb?cmd=scheduleCall).
3) Fill me in on what role you currently play in your parent’s care
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: eldercare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help you and your family.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: eldercare'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) [Add your parent’s information](better://nb?cmd=showProfile)
2) Message me about your parent’s conditions or [schedule a time to talk](better://nb?cmd=scheduleCall).
3) Fill me in on the role you play in your parent’s care?
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: eldercare'}, text: MESSAGE.strip())

# Medical question --

NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answering a medical question', active: true, ordinal: 3)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’ll be available *|pha_next_available|* to help answer your medical question. If you are experiencing any symptoms and would like to speak to an expert Mayo Clinic Nurse, tap the phone button above.

Here are a few simple things I need to get started:

1) Add your medical conditions to your [health profile](better://nb?cmd=showMedicalInformation)
2) Message me details about your medical question, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical question'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical question'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) [Add your medical conditions to your health profile](better://nb?cmd=showMedicalInformation)
2) Message me details about your medical question, or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical question'}, text: MESSAGE.strip())

# Losing some weight --

NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'losing some weight', active: false, ordinal: 2)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. I’m available *|pha_next_available|* to create a plan for your weight loss goals.

Here are a few simple things to get started:

1) Tell me a little more about your weight loss goals
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: weightloss'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Tell me more about how I can support your weight loss goals
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: weightloss'}, text: MESSAGE.strip())

# Something else --

NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'your health needs', active: true, ordinal: 1)

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*. I’ll be available *|pha_next_available|* to help with your health needs.

Here are a few simple things to get started:

1) Tell me a little more about the health issue you’d like to work on together
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: something else'}, text: MESSAGE.strip())

MESSAGE = <<eof
Welcome to Better, *|member_first_name|*! I’m here to help.
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: something else'}, text: MESSAGE.strip())

MESSAGE = <<eof
Here are a few simple things I need to get started:

1) Tell me more about what health topic you’d like to work on together
2) [Add medical conditions to your profile](better://nb?cmd=showMedicalInformation)
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: something else'}, text: MESSAGE.strip())
