class Api::V1::UsersController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :convert_parameters!, only: [:update]

  def show
    show_resource @user.serializer(serializer_options)
  end

  def update
    update_resource @user, permitted_params(@user).user, serializer_options: serializer_options
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user)
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

    # HACK - iOS and Care Portal are updating address in different places.  CONSOLIDATE ASAP
    address = params[:address]
    user_params[:address_attributes] = address if address

    user_params[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(include_nested_information: true) if current_user.care_provider?
    end
  end
end
