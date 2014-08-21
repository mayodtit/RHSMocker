OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.find_or_create_by_mkey(mkey: 'nux_question_text', mvalue: 'You’re invited to experience the service of a Personal Health Assistant. Choose an immediate need or focus for your free trial:')

# Provider search --

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'finding a new doctor or specialist', active: true, ordinal: 10)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - PROVIDER SEARCH
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: provider search'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - PROVIDER SEARCH
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: provider search'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - PROVIDER SEARCH
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: provider search'}, text: MESSAGE)

# Fighting a medical bill --

NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fighting a medical bill', active: true, ordinal: 9)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - BILLING
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: billing'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - BILLING
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: billing'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - BILLING
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: billing'}, text: MESSAGE)

# Managing medical conditions --

NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 8)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - MEDICAL CONDITION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical condition'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - MEDICAL CONDITION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical condition'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - MEDICAL CONDITION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical condition'}, text: MESSAGE)

# Caring for a child --

NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'caring for a child', active: true, ordinal: 7)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - CHILDCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: childcare'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - CHILDCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: childcare'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - CHILDCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: childcare'}, text: MESSAGE)

# Choosing new insurance --

NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choosing new insurance', active: true, ordinal: 6)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - CHOOSING INSURANCE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: choosing insurance'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - CHOOSING INSURANCE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: choosing insurance'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - CHOOSING INSURANCE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: choosing insurance'}, text: MESSAGE)

# Having a healthy baby --

NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy baby', phrase: 'having a healthy baby', active: true, ordinal: 5)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - PREGNANCY
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: pregnancy'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - PREGNANCY
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: pregnancy'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - PREGNANCY
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: pregnancy'}, text: MESSAGE)

# Caring for an aging parent --

NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'caring for an aging parent', active: true, ordinal: 4)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - ELDERCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: eldercare'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - ELDERCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: eldercare'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - ELDERCARE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: eldercare'}, text: MESSAGE)

# Caring for an aging parent --

NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answering a medical question', active: true, ordinal: 3)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - MEDICAL QUESTION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: medical question'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - MEDICAL QUESTION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: medical question'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - MEDICAL QUESTION
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: medical question'}, text: MESSAGE)

# Losing some weight --

NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'losing some weight', active: true, ordinal: 2)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - WEIGHTLOSS
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: weightloss'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - WEIGHTLOSS
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: weightloss'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - WEIGHTLOSS
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: weightloss'}, text: MESSAGE)

# Something else --

NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'your health needs', active: true, ordinal: 1)

MESSAGE = <<eof
PLACEHOLDER OFF HOURS - SOMETHING ELSE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Off Hours: something else'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER GREETING - SOMETHING ELSE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 1: something else'}, text: MESSAGE)

MESSAGE = <<eof
PLACEHOLDER INSTRUCTIONS - SOMETHING ELSE
eof
MessageTemplate.upsert_attributes({name: 'New Premium Member Part 2: something else'}, text: MESSAGE)
