class PermittedParams < Struct.new(:params, :current_user, :subject)
  def user
    params.require(:user).permit(*user_attributes).tap do |attributes|
      attributes.merge!(client_data: params.require(:user)[:client_data])
      if !current_user && params.require(:user)[:waitlist_entry]
        attributes.merge!(waitlist_entry: params.require(:user)[:waitlist_entry])
      end
    end
  end

  def secure_user
    params.require(:user).permit(*secure_user_attributes)
  end

  private

  def user_attributes
    base_user_attributes.tap do |attributes|
      if !current_user
        attributes.concat(secure_user_attributes)
      elsif current_user != subject
        attributes << :email
      end

      if current_user && current_user.admin?
        attributes << {user_information_attributes: user_information_attributes}
        attributes << {address_attributes: address_attributes}
        attributes << {insurance_policy_attributes: insurance_policy_attributes}
        attributes << {provider_attributes: provider_attributes}
      end
    end
  end

  def base_user_attributes
    [:first_name, :last_name, :avatar, :gender, :height, :birth_date, :phone,
     :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id, :deceased,
     :date_of_death, :npi_number, :expertise, :city, :state, :units, :nickname,
     :work_phone_number]
  end

  def secure_user_attributes
    if !current_user || current_user == subject
      [:email, :password]
    else
      nil
    end
  end

  def user_information_attributes
    [:id, :notes]
  end

  def address_attributes
    [:id, :address, :city, :state, :postal_code]
  end

  def insurance_policy_attributes
    [:id, :company_name, :plan_type, :policy_member_id, :notes]
  end

  def provider_attributes
    [:id, :address, :city, :state, :postal_code, :phone]
  end
end
