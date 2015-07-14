class Api::V1::UsersController < Api::V1::ABaseController
  before_filter :load_users, only: :index
  before_filter :load_user!, only: %i(show update secure_update)

  def index
    render_success(users: @users.includes(:pha).serializer(list: true),
                   page: page,
                   per: per,
                   total_count: @users.total_count)
  end

  def show
    render_success(user: @member.serializer(serializer_options),
                   member: @member.serializer(serializer_options))
  end

  def update
    if @user.update_attributes(permitted_params(@user).user)
      @user = User.find(@user.id) # force reload of CarrierWave image for correct URL
      render_success(user: @member.serializer(serializer_options),
                     member: @member.serializer(serializer_options))
    else
      render_failure({reason: error_reason_string}, 422)
    end
  end

  def secure_update
    if @user.update_attributes(permitted_params(@user).secure_user)
      render_success(user: @user.serializer,
                     member: @user.serializer)
    else
      render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user, current_user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
    render_success
  end

  private

  def load_users!
    authorize! :index, User
    search_params = params.permit(:pha_id, :is_premium, :status)

    # TODO - is this still used?
    if search_params[:is_premium] == 'true'
      search_params[:status] = Member::PREMIUM_STATES
      search_params.except!(:is_premium)
    end

    @users = Member.signed_up.where(search_params).order('users.last_contact_at DESC')
    @users = @users.name_search(params[:q]) if params[:q] # TODO - is this still needed?
    @users = @users.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end

  def load_user!
    @user = if params[:id] == 'current'
              current_user
            else
              User.find(params[:id])
            end
    authorize! :manage, @user
  end

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def update_params
    user_params.tap do |attrs|
      %i(user_information address insurance_policy provider emergency_contact).each do |key|
        attrs["#{key}_attributes".to_sym] = attrs[key] if attrs[key]
      end

      attrs[:address_attributes] = params[:address] if params[:address]
      attrs[:addresses_attributes] = [attrs[:address_attributes]]

      attrs[:avatar] = decode_b64_image(attrs[:avatar]) if attrs[:avatar]

      attrs[:actor_id] = current_user.id
    end
  end

  def serializer_options
    {}.tap do |options|
      options[:include_roles] = true if current_user.care_provider?
      options[:include_nested_information] = true if current_user.care_provider?
      options[:include_onboarding_information] = true if current_user.care_provider?
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
