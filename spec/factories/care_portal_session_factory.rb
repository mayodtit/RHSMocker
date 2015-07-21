# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :care_portal_session, class: CarePortalSession, parent: :session do
    queue_mode :pha
  end
end
