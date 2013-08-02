FactoryGirl.define do
  factory :message do
    encounter
    user { encounter.users.first }
    text {"I don't feel well."}

    trait :with_content do
      content
    end

    trait :with_location do
      location
    end

    trait :with_attachments do
      attachments {|a| [a.assocation(:attachment)]}
    end

    trait :with_vocabularies do
      message_mayo_vocabularies {|mvm| [mvm.association(:message_mayo_vocabulary)]}
    end
  end
end
