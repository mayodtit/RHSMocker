FactoryGirl.define do
  factory :mayo_vocabulary do
    sequence(:title) {|n| "Vocabulary #{n}" }
    sequence(:mcvid) {|n| "MCVID #{n}" }
  end
end
