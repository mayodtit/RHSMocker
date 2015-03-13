class InsurancePolicySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :company_name, :plan_type, :plan, :group_number,
             :effective_date, :termination_date, :member_services_number, :family_individual, :employer_exchange,
             :authorized, :policy_member_id, :notes, :subscriber_name, :insurance_card_front_image_url, :insurance_card_back_image_url,
             :summary

  def insurance_card_front_image_url
    object.insurance_card_front.try(:url)
  end

  def insurance_card_back_image_url
    object.insurance_card_back.try(:url)
  end

  def summary
    [
      key_value_hash('Company Name', company_name),
      key_value_hash('Member ID', policy_member_id),
      key_value_hash('Plan', plan),
      key_value_hash('Group Number', group_number),
      key_value_hash('Effective Date', effective_date.try(:strftime, "%m-%d-%Y")),
      key_value_hash('Termination Date', termination_date.try(:strftime, "%m-%d-%Y")),
      key_value_hash('Family/Individual', family_individual.try(:capitalize)),
      key_value_hash('Employer/Exchange', employer_exchange.try(:capitalize)),
    ].compact
  end

  def key_value_hash(key, value)
    return nil unless key && value
    {
      key: key,
      value: value
    }
  end
end
