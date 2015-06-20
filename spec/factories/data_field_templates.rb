FactoryGirl.define do
  factory :data_field_template do
    service_template
    sequence(:name) {|n| "DataFieldTemplate #{n}"}
    type 'boolean'
    required_for_service_start false
  end
end
