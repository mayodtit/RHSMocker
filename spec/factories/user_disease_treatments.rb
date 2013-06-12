FactoryGirl.define do
  factory :user_disease_treatment do
    user
    treatment
    user_disease { association :user_disease, :user => user }
    prescribed_by_doctor      true
    start_date                { Date.today }
    end_date                  nil
    sequence(:time_duration)  {|n| n+1 }
    time_duration_unit        'hour(s)'
    sequence(:amount)         {|n| n+1 }
    amount_unit               'pills'
    side_effect               false
    successful                nil
  end
end
