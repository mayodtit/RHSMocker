class Api::V1::MembersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: [:show, :update]
  before_filter :convert_legacy_parameters!, only: :secure_update # TODO - remove when deprecated routes are removed
  before_filter :load_member_from_login!, only: :secure_update
  before_filter :load_referral_code!, only: :create
  before_filter :load_onboarding_group!, only: :create
  before_filter :load_enrollment!, only: :create
  before_filter :convert_parameters!, only: [:create, :update, :update_current]

  def index
    render_success(users: @members.includes(:pha).serializer(list: true),
                   page: page,
                   per: per,
                   total_count: @members.total_count)
  end

  def show
    render_success user: @member.serializer(serializer_options),
                   member: @member.serializer(serializer_options)
  end

  def current
    render_success user: current_user.serializer(include_roles: true),
                   member: current_user.serializer(include_roles: true)
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @member = Member.create create_attributes
        if @member.errors.empty?
          @session = @member.sessions.create
          if user_params[:payment_token]
            CreateStripeSubscriptionService.new(user: @member,
                                                plan_id: 'bp20',
                                                credit_card_token: user_params[:payment_token],
                                                trial_end: Time.zone.now.pacific.end_of_day + 1.month,
                                                coupon_code: coupon_code).call
          end
          SendWelcomeEmailService.new(@member).call
          SendConfirmEmailService.new(@member).call
          SendDownloadLinkService.new(@member.phone).call if send_download_link?
          SendEmailToStakeholdersService.new(@member).call
          NotifyReferrerWhenRefereeSignUpService.new(@referral_code, @member).call if @referral_code

          render_success user: @member.serializer,
                         member: @member.reload.serializer,
                         pha_profile: @member.pha.try(:pha_profile).try(:serializer),
                         auth_token: @session.auth_token
        else
          render_failure({reason: @member.errors.full_messages.to_sentence,
                          user_message: @member.errors.full_messages.to_sentence}, 422)
        end
      end
    rescue Stripe::CardError => e
      render_failure({reason: e.as_json['code'],
                      user_message: e.as_json['message']}, 422) and return
    rescue Stripe::StripeError => e
      render_failure({reason: e.to_s,
                      user_message: "There's an error with your credit card, please try another one"}, 422) and return
    end
  end

  def update
    if @member.update_attributes(permitted_params(@member).user)
      render_success user: @member.serializer(serializer_options),
                     member: @member.serializer(serializer_options)
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  def update_current
    if current_user.update_attributes(permitted_params(current_user).user)
      @member = Member.find(current_user.id) # force reload of CarrierWave image for correct URL
      render_success user: @member.serializer,
                     member: @member.serializer
    else
      render_failure({reason: current_user.errors.full_messages.to_sentence}, 422)
    end
  end

  def secure_update
    if @member.update_attributes(permitted_params(@member).secure_user)
      render_success user: @member.serializer,
                     member: @member.serializer
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_members!
    authorize! :index, Member
    search_params = params.permit(:pha_id, :is_premium, :status)
    if search_params.has_key?(:is_premium) && (search_params[:is_premium] == 'true')
      search_params[:status] = Member::PREMIUM_STATES
      search_params.except!(:is_premium)
    end

    @members = Member.signed_up.where(search_params).order('users.last_contact_at DESC')
    @members = @members.name_search(params[:q]) if params[:q]
    @members = @members.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end

  def load_member!
    @member = Member.find(params[:id])
    authorize! :manage, @member
  end

  def convert_legacy_parameters!
    if update_email_path?
      params[:user] = {current_password: params[:password], email: params[:email]}
    elsif update_password_path?
      params[:user] = {current_password: params[:current_password], password: params[:password]}
    end
  end

  def update_email_path?
    request.env['PATH_INFO'].include?('update_email')
  end

  def update_password_path?
    request.env['PATH_INFO'].include?('update_password')
  end

  def load_member_from_login!
    @member = login(current_user.email, params.require(:user).require(:current_password))
    render_failure({reason: 'Current password is invalid'}, 422) and return unless @member
    authorize! :manage, @member
  end

  def load_referral_code!
    @referral_code = ReferralCode.find_by_code(user_params[:code]) if user_params[:code]
  end

  def load_onboarding_group!
    @onboarding_group = @referral_code.try(:onboarding_group)
    @onboarding_group ||= OnboardingGroup.find_by_name('Generic 14-day trial onboarding group') if Metadata.signup_free_trial?
  end

  def coupon_code
    @onboarding_group ? @onboarding_group.stripe_coupon_code : nil
  end

  def load_enrollment!
    @enrollment = Enrollment.find_by_token(user_params[:enrollment_token]) if user_params[:enrollment_token]
  end

  def convert_parameters!
    user_params[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]
    %w(user_information address insurance_policy provider emergency_contact).each do |key|
      user_params["#{key}_attributes".to_sym] = user_params[key.to_sym] if user_params[key.to_sym]
    end
    user_params[:addresses_attributes] = [user_params[:address_attributes]] if user_params[:address_attributes]
    user_params[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
    user_params[:actor_id] = current_user.id if current_user
  end

  def user_agreements_attributes
    return [] unless Agreement.active
    if user_params[:agreement_id]
      [
        {
          agreement_id: user_params[:agreement_id],
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    elsif user_params[:tos_checked] && Metadata.allow_tos_checked?
      [
        {
          agreement_id: Agreement.active.id,
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    end
  end

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(include_nested_information: true, include_roles: true) if current_user.care_provider?
      options.merge!(include_onboarding_information: true) if current_user.admin? || current_user.pha? || current_user.pha_lead?
    end
  end

  def create_attributes
    permitted_params.user.tap do |attributes|
      attributes[:referral_code] = @referral_code if @referral_code
      attributes[:onboarding_group] = @onboarding_group if @onboarding_group
      attributes[:enrollment] = @enrollment if @enrollment
      attributes[:time_zone] = params[:device_properties].try(:[], :device_timezone)
    end
  end

  def send_download_link?
    params[:send_download_link]
  end
end
