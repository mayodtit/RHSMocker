FactoryGirl.define do
  factory :content_reference do
    association :referrer, factory: :content
    association :referee, factory: :content
  end
end
