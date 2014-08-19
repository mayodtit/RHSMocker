OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.find_or_create_by_mkey(mkey: 'nux_question_text', mvalue: 'First, choose what you need help with. Then we’ll pair you up with a Personal Health Assistant to work with you and your loved ones.')

NuxAnswer.upsert_attributes({name: 'provider search'}, text: 'Finding a new doctor or specialist', phrase: 'finding a new doctor or specialist', active: true, ordinal: 10)
NuxAnswer.upsert_attributes({name: 'billing'}, text: 'Fighting a medical bill', phrase: 'fighting a medical bill', active: true, ordinal: 9)
NuxAnswer.upsert_attributes({name: 'medical condition'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 8)
NuxAnswer.upsert_attributes({name: 'childcare'}, text: 'Caring for a child', phrase: 'caring for a child', active: true, ordinal: 7)
NuxAnswer.upsert_attributes({name: 'choosing insurance'}, text: 'Choosing new insurance', phrase: 'choosing new insurance', active: true, ordinal: 6)
NuxAnswer.upsert_attributes({name: 'pregnancy'}, text: 'Having a healthy baby', phrase: 'having a healthy baby', active: true, ordinal: 5)
NuxAnswer.upsert_attributes({name: 'eldercare'}, text: 'Caring for an aging parent', phrase: 'caring for an aging parent', active: true, ordinal: 4)
NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answering a medical question', active: true, ordinal: 3)
NuxAnswer.upsert_attributes({name: 'medical question'}, text: 'Answering a medical question', phrase: 'answering a medical question', active: true, ordinal: 2)
NuxAnswer.upsert_attributes({name: 'weightloss'}, text: 'Losing some weight', phrase: 'losing some weight', active: true, ordinal: 1)
NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'working with you', active: true, ordinal: 0)
