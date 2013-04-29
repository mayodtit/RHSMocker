FactoryGirl.define do
  factory :diet do   
    name { ['Vegan', 'Vegetarian', 'Kosher', 'Halal'].sample }
  end
end
