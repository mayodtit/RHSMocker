FactoryGirl.define do
  factory :feature_flag , class: FeatureFlag, parent: :metadata do
    description 'This is a feature'
  end
end
