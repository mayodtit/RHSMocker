FactoryGirl.define do
  factory :task_template_set do
    result true
    parent_id 1
    service_template_id 2
    affirmative_child_id 3
    negative_child_id 4
  end
end
