mw = MessageWorkflow.find_or_create_by_name(name: 'Automated Onboarding')

AUTOMATED_ONBOARDING_MESSAGE_1 = "Hi *|member_first_name|*, I'm " +
  "*|sender_first_name|*, your Personal Health Assistant, and I’m here to " +
  "help simplify your health care experience. First, I'd like to get to " +
  "know you with a 10-minute Welcome Call so I can design a comprehensive " +
  "plan to work on together. You can schedule it through the app, or just " +
  "send me a time that works for you."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_1})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 1})

AUTOMATED_ONBOARDING_MESSAGE_2 = "Hi *|member_first_name|*,\n" +
  "I know you’re busy, but that's why I'm here. Take 10 minutes for your " +
  "health and let's get started with a welcome call. Here are a few ways " +
  "I've helped our members:\n" +
  " -Find a doctor or specialist and book an appointment\n" +
  " -Answer insurance questions\n" +
  " -Set up home prescription delivery\n" +
  " -Work on a healthy eating routine\n" +
  "Is there anything we can get started with right away? Just reply below."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_2})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 2})

AUTOMATED_ONBOARDING_MESSAGE_3 = "In addition to your yearly physical, " +
  "dentist appointment, and flu shot, you should also have the following " +
  "tests done:\n" +
  " -Blood pressure and blood sugar check every 2 years\n" +
  " -Full blood panel every 5 years\n" +
  " -Eye exam every 5-10 years if you have no vision problems\n" +
  "Are you up to date? Let me find you a primary care doctor or optometrist " +
  "and book you an appointment."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_3})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 4})

AUTOMATED_ONBOARDING_MESSAGE_4 = "Do you have any family members you would " +
  "like to add to your membership? I can provide services for anyone you " +
  "consider family."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_4})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 6})

AUTOMATED_ONBOARDING_MESSAGE_5 = "Hi *|member_first_name|*,\n" +
  "Are you ready for the summer sun? Consider these helpful tips for " +
  "sunscreen.\n" +
  "Find:\n" +
  " - SPF 30 or higher\n" +
  " - \"Broad Spectrum\" to protect against UVA/UVB rays\n" +
  " - Water Resistant for 40-80 min\n" +
  "Apply:\n" +
  " - 30 min before going outdoors\n" +
  " - Repeat every 2 hours\n" +
  "Reduce exposure:\n" +
  " - Avoid peak hours (10am-2pm) even on overcast days\n" +
  " - Wear protective clothing (e.g., swim shirts, long sleeves and hats)\n" +
  " - Check sunscreen expiration date"
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 5'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_5})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 8})

AUTOMATED_ONBOARDING_MESSAGE_6 = "Hi *|member_first_name|*,\n\n" +
"Your free trial ends today, but you can extend your Better Premium " +
"membership by going to your \"Health Profile,\" tapping on \"Settings\" " +
"and then on \"Subscription Plan\". There you will enter your credit card " +
"number to subscribe for $49.99 a month.\n\n" +
"If you decide it's not for you right now, please enjoy free access to our " +
"library of Mayo Clinic content. You can always subscribe later if you " +
"change your mind and need assistance with your healthcare needs.\n\n" +
"Take care,\n" +
"*|sender_first_name|*"
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 6'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_6})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 10})

OFFBOARD_ENGAGED_MEMBER = "I wanted to let you know that your free trial " +
  "ends tomorrow. If you’d like to keep working together, you can become " +
  "a Premium member by going to your \"Health Profile,\" tapping on " +
  "\"Settings\" and then on \"Subscription Plan.\" Your membership covers " +
  "service for you and your entire family. If you have any questions, " +
  "send a note to support@getbetter.com.\n" +
  "It's been great getting to know you, and I hope I can continue helping " +
  "you with your health needs."
MessageTemplate.upsert_attributes({name: 'Offboard Engaged Member'},
                                  {text: OFFBOARD_ENGAGED_MEMBER})

NEW_PREMIUM_MEMBER = "Hi *|member_first_name|*, welcome to Better. I’m " +
  "*|sender_first_name|*, your Personal Health Assistant. I’m here to " +
  "handle any of your health needs, so you can focus on being well. Let’s " +
  "get started with a 10-minute call: " +
  "[schedule here](better://nb?cmd=scheduleCall). If you have any questions " +
  "or immediate needs, just send me a message."
MessageTemplate.upsert_attributes({name: 'New Premium Member'},
                                  {text: NEW_PREMIUM_MEMBER})

CONFIRM_WELCOME_CALL = "Thanks for scheduling your call. We've sent you a " +
  "confirmation email with a calendar invite. *|pha_first_name|* will " +
  "speak with you soon."
MessageTemplate.upsert_attributes({name: 'Confirm Welcome Call'},
                                  {text: CONFIRM_WELCOME_CALL})
