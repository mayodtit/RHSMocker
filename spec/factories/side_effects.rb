FactoryGirl.define do
  factory :side_effect do
    sequence(:name) {|n| "SideEffect #{n}"}
    description 'May cause excessive nonsensical outbursts'
  end
end
