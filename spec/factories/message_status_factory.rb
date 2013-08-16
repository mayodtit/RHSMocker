FactoryGirl.define do

  factory :message_status do
    message nil
    user nil
    status "unread"
  end
end
