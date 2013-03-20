FactoryGirl.define do

  factory :message do
    text              "I don't feel well."
    user              { FactoryGirl.create(:user) }
    user_location     { FactoryGirl.create(:user_location) }
    attachments       { [FactoryGirl.create(:attachment)] }
    mayo_vocabularies { [FactoryGirl.create(:mayo_vocabulary)] }
    encounter         { FactoryGirl.create(:encounter) }
  end

end
