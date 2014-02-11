FactoryGirl.define do
  factory :member_association, class: MemberAssociation do
    association :user, factory: :member
    association :associate, factory: :member
    association_type
    state :pending

    trait :enabled do
      state :enabled
    end

    trait :disabled do
      state :disabled
    end
  end
end
