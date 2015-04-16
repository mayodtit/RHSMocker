FactoryGirl.define do
  factory :user_file do
    association :user, factory: :member
    file File.new(Rails.root.join('spec', 'support', 'kbcat.jpg'))
  end
end
