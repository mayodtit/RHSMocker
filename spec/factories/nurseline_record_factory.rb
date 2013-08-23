FactoryGirl.define do
  factory :nurseline_record do
    sequence(:payload) {|n| "nurseline_record #{n}"}
  end
end
