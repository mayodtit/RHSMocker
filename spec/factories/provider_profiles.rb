# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider_profile do
    id ""
    npi_number "1234567890"
    first_name "Bob"
    last_name "Doctor"
    image_url "https://asset1.betterdoctor.com/images/539b48fe4214f828a3000055-1_thumbnail.jpg"
    gender "male"
    ratings "[4,5]"
  end
end
