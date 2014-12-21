FactoryGirl.define do
  factory :insurance_policy do
    user
    company_name "InsurancePolicy company name"
    plan_type "InsurancePolicy plan type"
    plan "InsurancePolicy plan"
    sequence(:policy_member_id) {|n| "InsurancePolicy policy member id #{n}"}
    sequence(:group_number) {|n| "InsurancePolicy group number #{n}"}
    effective_date "12/11/1989"
    termination_date "12/12/1989"
    sequence(:member_services_number) {|n| "InsurancePolicy member services number #{n}"}
    authorized false
    insurance_image "InsuranceImage Insurance Image"
    sequence(:user_image_id) {|n| "InsurancePolicy Insurance image id #{n}"}
    sequence(:user_image_client_guid) {|n| "InsurancePolicy Insurance image client guid #{n}"}
    image :base64_test_image
    subscriber_name "InsurancePolicy subscriber name"
    family_individual "InsurancePolicy Family Individual"
    employer_individual "InsurancePolicy Employer Individual"
    employer_exchange "InsurancePolicy Employer Exchange"
    notes "InsurancePolicy notes"
  end
end
