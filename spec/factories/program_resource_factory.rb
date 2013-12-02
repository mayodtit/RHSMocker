FactoryGirl.define do
  factory :program_resource do
    program
    association :resource, factory: :content
  end
end
