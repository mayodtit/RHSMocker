OnboardingGroup.find_or_create_by_name(name: 'Generic 14-day trial onboarding group',
                                       premium: true,
                                       free_trial_days: 14)

NuxAnswer.upsert_attributes({name: 'medical conditions'}, text: 'Managing medical conditions', phrase: 'managing medical conditions', active: true, ordinal: 2)
NuxAnswer.upsert_attributes({name: 'something else'}, text: 'Something else', phrase: 'working with you', active: true, ordinal: 1)
