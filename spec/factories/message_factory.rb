FactoryGirl.define do
  factory :message do
    user
    encounter
    text {"I don't feel well."}

    trait :with_content do
      content
    end

    trait :with_location do
      user_location
    end

    trait :with_attachments do
      attachments {|a| [a.assocation(:attachment)]}
    end

    trait :with_vocabularies do
      mayo_vocabularies_messages {|mvm| [mvm.association(:mayo_vocabularies_message)]}
    end
  end
end
