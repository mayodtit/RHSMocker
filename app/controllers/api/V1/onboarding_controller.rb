class Api::V1::OnboardingController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_related!

  def sign_up
    sign_up_service = SignUpService.new.call
    if sign_up_service[:success?]
      render_success(user: @member.serializer,
                     member: @member.reload.serializer,
                     pha_profile: @member.pha.try(:pha_profile).try(:serializer),
                     auth_token: @session.auth_token)
    else
      render_failure({reason: @member.errors.full_messages.to_sentence,
                      user_message: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_related!
    @referral_code = ReferralCode.find_by_code(user_params[:code]) if user_params[:code]
    @onboarding_group = @referral_code.try(:onboarding_group)
    @enrollment = Enrollment.find_by_token(user_params[:enrollment_token]) if user_params[:enrollment_token]
  end

  def sign_up_attributes
    permitted_params.user.tap do |attrs|
      attrs[:referral_code] = @referral_code if @referral_code
      attrs[:onboarding_group] = @onboarding_group if @onboarding_group
      attrs[:enrollment] = @enrollment if @enrollment
      attrs[:time_zone] = params[:device_properties].try(:[], :device_timezone)
      attrs[:user_agreements_attributes] = user_agreements_attributes if user_params[:agreement_id] || user_params[:tos_checked]
    end
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

  def send_download_link?
    params[:send_download_link]
  end

  def mayo_pilot_2?
    @onboarding_group.try(:name) == 'Mayo Pilot 2'
  end
end
