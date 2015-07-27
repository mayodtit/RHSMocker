FactoryGirl.define do
  factory :data_field_change do
    data_field
    association :actor, factory: :member
    data { {hello: :world} }
  end
end
