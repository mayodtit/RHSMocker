FactoryGirl.define do
  factory :message_template do
    sequence(:name) {|n| "MessageTemplate #{n}"}
    text "Hello World."
    subject 'Subject Yo.'
  end
end
