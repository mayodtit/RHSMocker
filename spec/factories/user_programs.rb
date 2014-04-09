FactoryGirl.define do
  factory :user_program do
    association :user, factory: :member
    program
    subject { user }
  end
end
