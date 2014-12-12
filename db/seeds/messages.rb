# Current Messages --

CONFIRM_WELCOME_CALL = "Thanks for scheduling your call. We've sent you " +
  "a confirmation email with a calendar invite. Be sure to start filling " +
  "out your Health Profile; it's in the navigation menu at the top left " +
  "of your screen. *|pha_first_name|* will speak with you soon."
MessageTemplate.upsert_attributes({name: 'Confirm Welcome Call'},
                                  {text: CONFIRM_WELCOME_CALL})

WELCOME_CALL_REMINDER = "I'm looking forward to our call *|day|*. Let me " +
  "know if you have any questions or need to reschedule."
m = MessageTemplate.upsert_attributes({name: 'Welcome Call Reminder'},
                                      {text: WELCOME_CALL_REMINDER})

# Onboarding
cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding 8/22/14')

AUTOMATED_ONBOARDING_MESSAGE_1 = <<eof
  *|member_first_name|*, thanks for signing up. I’m here to help you *|nux_answer|*. Let’s have a quick conversation so I can learn more. Message me here or [schedule a time to talk](better://nb?cmd=scheduleCall).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message Day 2 8/22/14'},
                                      {text: AUTOMATED_ONBOARDING_MESSAGE_1.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 1})

AUTOMATED_ONBOARDING_MESSAGE_2 = <<eof
  Hi there. You might be busy, but I’m here to help. Let me know what you’d like me to get started on. Send me a message or just call now.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message Day 3 8/22/14'},
                                      {text: AUTOMATED_ONBOARDING_MESSAGE_2.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 3})

AUTOMATED_ONBOARDING_EMAIL_2 = <<eof
Hi *|member_first_name|*,

I'm *|pha_first_name|*, your Personal Health Assistant from Better. I'd like to get started helping you *|nux_answer|*, but first, I need a bit more information. Take a minute and send me a message in the app. To see my messages as they come in, turn on Push Notifications within Settings on your phone.

Take care,
*|pha_first_name|*
eof
AUTOMATED_ONBOARDING_EMAIL_2_SUBJECT = 'Checking in'
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Email Day 5 8/22/14'},
                                      {subject: AUTOMATED_ONBOARDING_EMAIL_2_SUBJECT,
                                       text: AUTOMATED_ONBOARDING_EMAIL_2.strip()})
PlainTextEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                  message_template_id: m.id},
                                                 {relative_days: 5})

AUTOMATED_ONBOARDING_MESSAGE_3 = <<eof
  Just checking in -- do you have time to connect?
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message Day 5 8/22/14'},
                                      {text: AUTOMATED_ONBOARDING_MESSAGE_3.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 5})

AUTOMATED_ONBOARDING_MESSAGE_4 = <<eof
  How are you feeling today, *|member_first_name|*? Our Mayo Clinic nurses can expertly handle any of your medical questions or symptoms.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message Day 7 8/22/14'},
                                      {text: AUTOMATED_ONBOARDING_MESSAGE_4.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 7})

AUTOMATED_ONBOARDING_EMAIL_3 = 'automated_onboarding_testimonials_email'
TemplateEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                 template: AUTOMATED_ONBOARDING_EMAIL_3},
                                                {relative_days: 8})

# Offboarding
cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Offboarding')

AUTOMATED_OFFBOARDING_MESSAGE_1 = "Your trial is ending " +
  "*|day_of_reference_event|*. Get in touch with your PHA today."
m = MessageTemplate.upsert_attributes({name: 'Automated Offboarding Message 1'},
                                      {text: AUTOMATED_OFFBOARDING_MESSAGE_1})
SystemMessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                 message_template_id: m.id},
                                                {relative_days: -1,
                                                 reference_event: :recipient_free_trial_ends_at})

AUTOMATED_OFFBOARDING_MESSAGE_2 = "Hi *|member_first_name|*, Thank you for " +
  "your interest in Better. I wanted to let you know that your free trial " +
  "ends today. If you'd like to become a Premium member, tap " +
  "[here](better://nb?cmd=showSubscription). If you have any questions " +
  "about your trial, please let me know."
m = MessageTemplate.upsert_attributes({name: 'Automated Offboarding Message 2'},
                                      {text: AUTOMATED_OFFBOARDING_MESSAGE_2})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 0,
                                           reference_event: :recipient_free_trial_ends_at})

AUTOMATED_OFFBOARDING_EMAIL_1 = "Hi *|member_first_name|*,\n\n" +
  "Thank you for your interest in Better. I wanted to let you know your " +
  "free trial ends today, and although we didn't get a chance to work " +
  "together, I hope I can serve you in the future. If you have a moment, " +
  "let us know how we could improve this experience for you, share " +
  "your thoughts here: http://svy.mk/1mJEv44.\n\n" +
  "If you have any questions about your trial, send a note to " +
  "support@getbetter.com.\n\n" +
  "Take care,\n" +
  "*|pha_first_name|*"
AUTOMATED_OFFBOARDING_EMAIL_1_SUBJECT = "Your trial ends today"
m = MessageTemplate.upsert_attributes({name: 'Automated Offboarding Email 1'},
                                      {subject: AUTOMATED_OFFBOARDING_EMAIL_1_SUBJECT,
                                       text: AUTOMATED_OFFBOARDING_EMAIL_1})
PlainTextEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                  message_template_id: m.id},
                                                 {relative_days: 0,
                                                  reference_event: :recipient_free_trial_ends_at})

AUTOMATED_OFFBOARDING_MESSAGE_3 = "We're sorry to see you go. If you decide " +
  "you'd like to upgrade later tap [here](better://nb?cmd=showSubscription) " +
  "and you can pick back up where you left off."

m = MessageTemplate.upsert_attributes({name: 'Automated Offboarding Message 3'},
                                      {text: AUTOMATED_OFFBOARDING_MESSAGE_3})
SystemMessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                 message_template_id: m.id},
                                                {relative_days: 1,
                                                 reference_event: :recipient_free_trial_ends_at})

# Old Messages --

NEW_PREMIUM_MEMBER = "Hi *|member_first_name|*, I'm " +
  "*|sender_first_name|*, your Personal Health Assistant. I'm here to " +
  "handle any of your health needs. Let's " +
  "get started with a 10-minute call: " +
  "[schedule here](better://nb?cmd=scheduleCall). If you have any questions " +
  "or immediate needs, just send me a message."
MessageTemplate.upsert_attributes({name: 'New Premium Member'},
                                  {text: NEW_PREMIUM_MEMBER})

NEW_PREMIUM_MEMBER_OLD = "Hi *|member_first_name|*, welcome to Better. I'm " +
  "*|sender_first_name|*, your Personal Health Assistant. I'm here to " +
  "handle any of your health needs, so you can focus on being well. Let me " +
  "know when you're available to get started with a 15-minute call. " +
  "If you have any questions or immediate needs, just send me a message here."
MessageTemplate.upsert_attributes({name: 'New Premium Member OLD'},
                                  {text: NEW_PREMIUM_MEMBER_OLD})

CONFIRM_WELCOME_CALL_OLD = "Thanks for scheduling your call. We've sent you " +
  "a confirmation email with a calendar invite. Be sure to start filling " +
  "out your Health Profile; it's in the navigation menu at the top left " +
  "of your screen. *|pha_first_name|* will speak with you soon."
MessageTemplate.upsert_attributes({name: 'Confirm Welcome Call OLD'},
                                  {text: CONFIRM_WELCOME_CALL_OLD})

cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding')

AUTOMATED_ONBOARDING_MESSAGE_1 = "Is there anything I can do for you " +
  "today, *|member_first_name|*? If you need help with your health " +
  "insurance, I can answer any questions, get your bills organized, " +
  "and evaluate your plan. [Schedule](better://nb?cmd=scheduleCall) a " +
  "quick call, and let me know what I can get started on for you."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_1})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 2})

AUTOMATED_ONBOARDING_EMAIL_1 = 'automated_onboarding_survey_email'
TemplateEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                 template: AUTOMATED_ONBOARDING_EMAIL_1},
                                                {relative_days: 2})

AUTOMATED_ONBOARDING_MESSAGE_2 = "Hi *|member_first_name|*, do you or any " +
  "of your family members need a new doctor or specialist? I can find one " +
  "for you, book appointments, and help you prepare.  Let's get started " +
  "with a [call](better://nb?cmd=scheduleCall), or just send me a message."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_2})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 4})

AUTOMATED_ONBOARDING_EMAIL_2 = "Hi *|member_first_name|*,\n\n" +
  "I'm *|pha_first_name|*, your Personal Health Assistant from Better. " +
  "I'd like to get started helping you *|nux_answer|*, but first, I " +
  "need a bit more information. Take a minute and send me a message in the " +
  "app. To see my messages as they come in, turn on Push Notifications " +
  "within Settings on your phone.\n\n" +
  "Take care,\n" +
  "*|pha_first_name|*"
AUTOMATED_ONBOARDING_EMAIL_2_SUBJECT = 'Checking in'
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Email 2'},
                                      {subject: AUTOMATED_ONBOARDING_EMAIL_2_SUBJECT,
                                       text: AUTOMATED_ONBOARDING_EMAIL_2})
PlainTextEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                  message_template_id: m.id},
                                                 {relative_days: 4})

AUTOMATED_ONBOARDING_MESSAGE_3 = "How are you feeling today, " +
  "*|member_first_name|*? If you need information about health conditions " +
  "or new symptoms, let me connect you to our Mayo Clinic nurses. " +
  "They'll expertly handle any of your medical questions. Tap the phone " +
  "button at the top right to give me a call or send me a message below."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_3})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 6})

AUTOMATED_ONBOARDING_EMAIL_3 = 'automated_onboarding_testimonials_email'
TemplateEmailWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                                 template: AUTOMATED_ONBOARDING_EMAIL_3},
                                                {relative_days: 7})

AUTOMATED_ONBOARDING_MESSAGE_4 = "What are your health goals, *|member_first_name|*? " +
  "Would you like me to help you work on better sleep, fitness, or " +
  "nutrition? Schedule a [call](better://nb?cmd=scheduleCall) or start " +
  "messaging me now."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_4})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 7})

OFFBOARD_ENGAGED_MEMBER = "I wanted to let you know that your free trial " +
  "ends tomorrow. If you'd like to keep working together, you can become " +
  "a Premium member by going to your \"Health Profile,\" tapping on " +
  "\"Settings\" and then on \"Subscription Plan.\" Your membership covers " +
  "service for you and your entire family. If you have any questions, " +
  "send a note to support@getbetter.com.\n" +
  "It's been great getting to know you, and I hope I can continue helping " +
  "you with your health needs."
MessageTemplate.upsert_attributes({name: 'Offboard Engaged Member'},
                                  {text: OFFBOARD_ENGAGED_MEMBER})

cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding OLD')

AUTOMATED_ONBOARDING_MESSAGE_1_OLD = "Is there anything I can do for you " +
  "today, *|member_first_name|*? If you need help with your health " +
  "insurance, I can answer any questions, get your bills organized, and " +
  "evaluate your plan. Let me know when you have time for a quick call " +
  "so I know what to get started on for you."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_1_OLD})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 2})

AUTOMATED_ONBOARDING_MESSAGE_2_OLD = "Hi *|member_first_name|*, do you or " +
  "any of your family members need a new doctor or specialist? I can find " +
  "one for you, book appointments, and help you prepare.  Let's get " +
  "started with a call, just send me a message with a few times and days, " +
  "or let me know your immediate needs right away."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_2_OLD})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 4})

AUTOMATED_ONBOARDING_MESSAGE_3_OLD = "How are you feeling today, " +
  "*|member_first_name|*? If you need information about health conditions " +
  "or new symptoms, let me connect you to our Mayo Clinic nurses. " +
  "They'll expertly handle any of your medical questions. Tap the phone " +
  "button at the top right to give me a call or send me a message below."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_3_OLD})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 6})

AUTOMATED_ONBOARDING_MESSAGE_4_OLD = "What are your health goals, " +
  "*|member_first_name|*? Would you like me to help you work on better " +
  "sleep, fitness, or nutrition? Start messaging me now."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_4_OLD})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 8})

TOS_VIOLATION = '*|member_first_name|*, due to violations of our terms of service, we will be terminating your account.'
m = MessageTemplate.upsert_attributes({name: 'TOS Violation'}, {text: TOS_VIOLATION})

FREE_ONBOARDING = "Want your very own PHA? Become a Better member by [tapping here](better://nb?cmd=showSubscription) and get a month free. Cancel at any time. No surprises, just better health."
m = MessageTemplate.upsert_attributes({name: 'Free Onboarding'}, {text: FREE_ONBOARDING})
