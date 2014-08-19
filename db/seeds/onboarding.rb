OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

Metadata.find_or_create_by_mkey(mkey: 'nux_question_text', mvalue: 'First, choose what you need help with. Then we’ll pair you up with a Personal Health Assistant to work with you and your loved ones.')
NuxAnswer.upsert_attributes({name: 'medical conditions'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 2)
NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'working with you', active: true, ordinal: 1)
