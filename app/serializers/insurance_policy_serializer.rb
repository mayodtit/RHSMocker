class InsurancePolicySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :company_name, :plan_type,
             :policy_member_id, :notes
end
