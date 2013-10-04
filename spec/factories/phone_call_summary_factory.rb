FactoryGirl.define do
  factory :phone_call_summary do
    association :caller, :factory => :member
    association :callee, :factory => :member
    body 'Phone call summary text'
  end
end
