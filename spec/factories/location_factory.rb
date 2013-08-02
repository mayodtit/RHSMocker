FactoryGirl.define do
  factory :location do
    user
    longitude { 30.23 }
    latitude { -10.43 }
  end
end
