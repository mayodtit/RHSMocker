FactoryGirl.define do
  factory :parsed_nurseline_record do
    association :user, factory: :member
    consult { association(:consult, initiator: user, subject: user) }
    phone_call { association(:phone_call, user: user) }
    nurseline_record
    sequence(:text) {|n| "Text for ParsedNurselineRecord #{n}"}
  end
end
