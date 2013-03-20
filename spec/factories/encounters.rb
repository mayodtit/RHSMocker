FactoryGirl.define do

  factory :encounter do
    status    { ['open', 'closed', 'on hold'].sample }
    priority  { ['high', 'medium', 'low'].sample }
    checked   false

    factory :encounter_with_messages do
      after(:create) { |encounter|
        FactoryGirl.create(:message, :text=> 'ouch my liver', :encounter=>encounter)
        FactoryGirl.create(:message, :text=> "that's not good", :encounter=>encounter)
      }
    end
  end

end
