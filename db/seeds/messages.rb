NEW_PREMIUM_MEMBER = "Hi *|member_first_name|*, welcome to Better. I'm " +
  "*|sender_first_name|*, your Personal Health Assistant. I'm here to " +
  "handle any of your health needs, so you can focus on being well. Let's " +
  "get started with a 10-minute call: " +
  "[schedule here](better://nb?cmd=scheduleCall). If you have any questions " +
  "or immediate needs, just send me a message."
MessageTemplate.upsert_attributes({name: 'New Premium Member'},
                                  {text: NEW_PREMIUM_MEMBER})

NEW_PREMIUM_MEMBER_OLD = "Hi *|member_first_name|*, welcome to Better. I'm " +
  "*|sender_first_name|*, your Personal Health Assistant. I'm here to " +
  "handle any of your health needs, so you can focus on being well. Let me " +
  "know when you're available to get started with a 10-minute call. " +
  "If you have any questions or immediate needs, just send me a message here."
MessageTemplate.upsert_attributes({name: 'New Premium Member OLD'},
                                  {text: NEW_PREMIUM_MEMBER_OLD})

CONFIRM_WELCOME_CALL = "Thanks for scheduling your call. We've sent you a " +
  "confirmation email with a calendar invite. Be sure to start filling out " +
  "your [Health Profile](better://nb?cmd=showProfile). *|pha_first_name|* " +
  "will speak with you soon."
MessageTemplate.upsert_attributes({name: 'Confirm Welcome Call'},
                                  {text: CONFIRM_WELCOME_CALL})

CONFIRM_WELCOME_CALL_OLD = "Thanks for scheduling your call. We've sent you " +
  "a confirmation email with a calendar invite. Be sure to start filling " +
  "out your Health Profile; it's in the navigation menu at the top left " +
  "of your screen. *|pha_first_name|* will speak with you soon."
MessageTemplate.upsert_attributes({name: 'Confirm Welcome Call OLD'},
                                  {text: CONFIRM_WELCOME_CALL_OLD})

mw = MessageWorkflow.find_or_create_by_name(name: 'Automated Onboarding')

AUTOMATED_ONBOARDING_MESSAGE_1 = "Is there anything I can do for you " +
  "today *|member_first_name|*? if you need help with your health " +
  "insurance, I can answer any questions, get your bills organized, " +
  "and evaluate your plan. [Schedule](better://nb?cmd=scheduleCall) a " +
  "quick call, and let me know what I can get started on for you."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_1})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 2})

AUTOMATED_ONBOARDING_MESSAGE_2 = "Hi *|member_first_name|*, do you or any " +
  "of your family members need a new doctor or specialist? I can find one " +
  "for you, book appointments, and help you prepare.  Let's get started " +
  "with a [call](better://nb?cmd=scheduleCall), or just send me a message."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_2})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 4})

AUTOMATED_ONBOARDING_MESSAGE_3 = "How are you feeling today " +
  "*|member_first_name|*? If you need information about health conditions " +
  "or new symptoms, let me connect you to our Mayo Clinic nurses. " +
  "They'll expertly handle any of your medical questions. Tap the phone " +
  "button at the top right to give me a call or send me a message below."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_3})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 6})

AUTOMATED_ONBOARDING_MESSAGE_4 = "What are your health goals, *|member_first_name|*? " +
  "Would you like me to help you work on better sleep, fitness, or " +
  "nutrition? Schedule a [call](better://nb?cmd=scheduleCall) or start " +
  "messaging me now."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_4})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 8})

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

mw = MessageWorkflow.find_or_create_by_name(name: 'Automated Onboarding OLD')

AUTOMATED_ONBOARDING_MESSAGE_1_OLD = "Is there anything I can do for you " +
  "today *|member_first_name|*? if you need help with your health " +
  "insurance, I can answer any questions, get your bills organized, and " +
  "evaluate your plan. Let me know when you have time for a quick call " +
  "so I know what to get started on for you."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 1 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_1_OLD})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 2})

AUTOMATED_ONBOARDING_MESSAGE_2_OLD = "Hi *|member_first_name|*, do you or " +
  "any of your family members need a new doctor or specialist? I can find " +
  "one for you, book appointments, and help you prepare.  Let's get " +
  "started with a call, just send me a message with a few times and days, " +
  "or let me know your immediate needs right away."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 2 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_2_OLD})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 4})

AUTOMATED_ONBOARDING_MESSAGE_3_OLD = "How are you feeling today " +
  "*|member_first_name|*? If you need information about health conditions " +
  "or new symptoms, let me connect you to our Mayo Clinic nurses. " +
  "They'll expertly handle any of your medical questions. Tap the phone " +
  "button at the top right to give me a call or send me a message below."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 3 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_3_OLD})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 6})

AUTOMATED_ONBOARDING_MESSAGE_4_OLD = "What are your health goals, " +
  "*|member_first_name|*? Would you like me to help you work on better " +
  "sleep, fitness, or nutrition? Start messaging me now."
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding Message 4 OLD'},
                                       {text: AUTOMATED_ONBOARDING_MESSAGE_4_OLD})
MessageWorkflowTemplate.upsert_attributes({message_workflow_id: mw.id,
                                           message_template_id: m.id},
                                          {days_delayed: 8})
