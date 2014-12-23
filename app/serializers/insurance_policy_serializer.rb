class InsurancePolicySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :company_name, :plan_type, :plan, :plan_types_medical, :plan_types_dental, :group_number,
             :effective_date, :termination_date, :member_services_number, :family_individual, :employer_individual, :employer_exchange,
             :authorized, :policy_member_id, :notes, :subscriber_name, :insurance_card_front_image_url, :insurance_card_back_image_url

  def insurance_card_front_image_url
    object.insurance_card_front.try(:url)
  end

  def insurance_card_back_image_url
    object.insurance_card_back.try(:url)
  end
end
