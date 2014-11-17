cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding - Something Else')

SOMETHING_ELSE_DAY_0 = <<-eof
Hi *|member_first_name|*, I’m excited to work together! I’ll help you achieve your health goals so that you’re healthy and happy. Message me or [tap here to choose a convenient time to chat](better://nb?cmd=scheduleCall). How does this sound to you?
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 0'},
                                      {text: SOMETHING_ELSE_DAY_0.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 0})

SOMETHING_ELSE_DAY_1 = <<-eof
Hi *|member_first_name|*, I’d love to get started by learning about your needs. Our members get the best results if they have a quick call to discuss their goals.[Tap here to choose a convenient time](better://nb?cmd=scheduleCall). Let me know if you don't find anything that works.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 1'},
                                      {text: SOMETHING_ELSE_DAY_1.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 1})

SOMETHING_ELSE_DAY_2 = <<-eof
Would you like to get started on your health goal? I’ll also help you schedule appointments, find the best doctors and get the most from your health insurance. We can work together through messaging or [book a call here](better://nb?cmd=scheduleCall).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 2'},
                                      {text: SOMETHING_ELSE_DAY_2.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 2})

SOMETHING_ELSE_DAY_3 = <<-eof
*|member_first_name|*, I know you’re busy but that's why I'm here. What can I help with? Just reply below.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 3'},
                                      {text: SOMETHING_ELSE_DAY_3.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 3})

SOMETHING_ELSE_DAY_4 = <<-eof
I can make health insurance easier to understand. We’ll work together to get the most out your plan, solve any billing problems and get you the best doctors. Just reply below to get started.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 4'},
                                      {text: SOMETHING_ELSE_DAY_4.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 4})

SOMETHING_ELSE_DAY_6 = <<-eof
Hi *|member_first_name|*. I'd like to get started helping you *|nux_answer|* and need a little more information. Take a minute to send me a message. To see my messages as they come in, make sure you’ve turned on Push Notifications within Settings on your iPhone. 
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 6'},
                                      {text: SOMETHING_ELSE_DAY_6.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 6})

SOMETHING_ELSE_DAY_8 = <<-eof
*|member_first_name|*, do you have any medical questions? Our Mayo Clinic nurses can give you expert advice. Just send a message if you’d like to connect.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 8'},
                                      {text: SOMETHING_ELSE_DAY_8.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 8})

SOMETHING_ELSE_DAY_11 = <<-eof
*|member_first_name|*, my team and I are here to support you. Whenever you’re ready, let’s have a quick conversation about *|nux_answer|*. Send me a message or call by tapping the phone button on the top right of your screen.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Something Else - Day 11'},
                                      {text: SOMETHING_ELSE_DAY_11.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 11})

#####
# Caring for an aging parent or child
#####
cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding - Caring For Parent/Child')

CARING_FOR_DAY_0 = <<-eof
Hi *|member_first_name|*, I’m looking forward to working with you! We’ll help you care for your loved ones so that they’re healthy and happy. Message me or [tap here to choose a convenient time to chat](better://nb?cmd=scheduleCall).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Caring For - Day 0'},
                                      {text: CARING_FOR_DAY_0.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 0})

CARING_FOR_DAY_1 = <<-eof
Hi *|member_first_name|*, I’d love to hear about who you’re caring for. Message me about them here and [add them to your profile](better://nb?cmd=newProfile).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Caring For - Day 1'},
                                      {text: CARING_FOR_DAY_1.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 1})

CARING_FOR_DAY_2 = <<-eof
Hi *|member_first_name|*, we know caring for loved ones is a big job. What can we help with?
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Caring For - Day 2'},
                                      {text: CARING_FOR_DAY_2.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 2})

m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 3')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 3})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 4')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 4})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 6')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 6})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 8')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 8})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 11')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 11})

#####
# Conception
#####
cw = CommunicationWorkflow.find_or_create_by_name(name: 'Automated Onboarding - Conception')

CONCEPTION_DAY_0 = <<-eof
Hi *|member_first_name|*, I’m here to support you as you grow your family. I’ll find new doctors, research alternative treatments, set up a wellness program, and check your insurance coverage. Message me about your situation and [schedule a time to talk with me here](better://nb?cmd=scheduleCall).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Conception - Day 0'},
                                      {text: CONCEPTION_DAY_0.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 0})

CONCEPTION_DAY_1 = <<-eof
Hi *|member_first_name|*, do you have time to connect? I’m here to support you in everything from setting up a medical team to making sure you’re covered for any treatments you may need. To get started, [add any medical conditions to your profile here](better://nb?cmd=newProfile).
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Conception - Day 1'},
                                      {text: CONCEPTION_DAY_1.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 1})

CONCEPTION_DAY_2 = <<-eof
Hey *|member_first_name|*, I’d love to talk about your needs while you’re planning for pregnancy. [Schedule a time to talk with me here](better://nb?cmd=scheduleCall) or send me a message.
eof
m = MessageTemplate.upsert_attributes({name: 'Automated Onboarding - Conception - Day 2'},
                                      {text: CONCEPTION_DAY_2.strip()})
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 2})

m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 3')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 3})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 4')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 4})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 6')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 6})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 8')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 8})
m = MessageTemplate.find_by_name('Automated Onboarding - Something Else - Day 11')
MessageWorkflowTemplate.upsert_attributes({communication_workflow_id: cw.id,
                                           message_template_id: m.id},
                                          {relative_days: 11})
