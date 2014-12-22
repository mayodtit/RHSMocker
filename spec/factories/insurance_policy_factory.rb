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
    subscriber_name "InsurancePolicy subscriber name"
    family_individual "InsurancePolicy Family Individual"
    employer_individual "InsurancePolicy Employer Individual"
    employer_exchange "InsurancePolicy Employer Exchange"
    insurance_card_front nil
    insurance_card_back nil
    sequence(:insurance_card_front_id) {|n| "InsurancePolicy Insurance Card Front Id#{n}"}
    sequence(:insurance_card_back_id) {|n| "InsurancePolicy Insurance Card Back Id#{n}"}
    sequence(:insurance_card_front_client_guid) {|n| "InsurancePolicy Insurance Card Front Client GUID#{n}"}
    sequence(:insurance_card_back_client_guid) {|n| "InsurancePolicy Insurance Card Back Client GUID#{n}"}
    notes "InsurancePolicy notes"
  end
end
