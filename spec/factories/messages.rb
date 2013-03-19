# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    text "MyString"
    user {FactoryGirl.create(:user)}
    user_location {FactoryGirl.create(:user_location)}
    attachments {[FactoryGirl.create(:attachment)]}
    mayo_vocabularies {[FactoryGirl.create(:mayo_vocabulary)]}
  end
end
