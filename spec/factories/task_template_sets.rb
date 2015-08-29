FactoryGirl.define do
  factory :task_template_set do
    service_template

    trait :has_affirmative_child do
      association :affirmative_child, factory: :task_template_set
    end

    trait :has_negative_child do
      association :negative_child, factory: :task_template_set
    end
  end
end
