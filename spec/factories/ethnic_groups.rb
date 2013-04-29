FactoryGirl.define do
  factory :ethnic_group do   
    name { ['Asian or Pacific Islander', 'Black', 'Hispanic'].sample }
  end
end
