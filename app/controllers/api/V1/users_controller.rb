class Api::V1::UsersController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :convert_parameters!, only: [:update]

  def show
    show_resource @user.serializer(serializer_options)
  end

  def update
    if @user.update_attributes(permitted_params(@user).user)
      render_success user: @user.serializer(serializer_options).as_json
    else
      render_failure({reason: error_reason_string}, 422)
    end
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user, current_user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
    render_success
  end

  private

  def load_user!
    @user = User.find_by_id(params[:id]) || current_user
    authorize! :manage, @user
  end

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def convert_parameters!
    %i(user_information address insurance_policy provider emergency_contact).each do |key|
      user_params["#{key}_attributes".to_sym] = user_params[key] if user_params[key]
    end

    user_params[:addresses_attributes] = [user_params[:address_attributes]]

    # HACK - iOS and Care Portal are updating address in different places.  CONSOLIDATE ASAP
    address = params[:address]
    user_params[:addresses_attributes] = [address] if address

    user_params[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]
    user_params[:actor_id] = current_user.id
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(include_nested_information: true) if current_user.care_provider?
    end
  end

  def error_reason_string
    if @user.errors[:phone_numbers].any?
      @association = current_user.associations.find_by_associate_id(@user.id)
      if @association.try(:association_type).try(:hcp?)
        return "Care Team Member's phone number is invalid"
      elsif @association.try(:association_type).try(:family?)
        return "Family Member's phone number is invalid"
      else
        return "Phone number is invalid"
      end
    end
    @user.errors.full_messages.to_sentence
  end
end
