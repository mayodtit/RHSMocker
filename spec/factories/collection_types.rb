FactoryGirl.define do
  factory :collection_type do
    sequence(:name) {|n| "CollectionType #{n}"}
  end
end
