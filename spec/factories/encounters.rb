# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :encounter do
    status    "open"
    priority  "medium"
    checked   false

    factory :encounter_with_messages do
      messages {[FactoryGirl.create(:message, :text=>"ouch my liver"), FactoryGirl.create(:message, :text=>"that's not good")]}
    end
  end
end
