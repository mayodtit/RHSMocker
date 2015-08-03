FactoryGirl.define do
  factory :system_action do
    system_event
    system_action_template { association(:system_action_template, system_event_template: system_event.system_event_template) }
    result { association(:message, consult: system_event.user.master_consult, user: Member.robot, text: 'System action result message') }
  end
end
