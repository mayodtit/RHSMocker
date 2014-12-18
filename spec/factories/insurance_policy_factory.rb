FactoryGirl.define do
  factory :insurance_policy do
    user
    company_name "InsurancePolicy company name"
    plan_type "InsurancePolicy plan type"
    sequence(:policy_member_id) {|n| "InsurancePolicy policy member id #{n}"}
    notes "notes"
  end
end
