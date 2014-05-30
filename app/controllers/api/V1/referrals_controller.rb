class Api::V1::ReferralsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_referral_code
  before_filter :load_onboarding_group
  before_filter :load_users!

  def create
    @user = @users.create(create_attributes)
    if @user.errors.empty?
      Mails::InvitationJob.create(@user.id, invite_url(@user.invitation_token))
    end
    render_success
  end

  private

  def load_referral_code
    @referral_code = ReferralCode.find_by_code(params[:code]) if params[:code]
  end

  def load_onboarding_group
    @onboarding_group = @referral_code.try(:onboarding_group)
  end

  def load_users!
    @users = @onboarding_group ? @onboarding_group.users : Member.scoped
  end

  def create_attributes
    params.permit(:email).tap do |attributes|
      attributes[:referral_code] = @referral_code if @referral_code
      attributes[:invitation_token] = invitation_token
    end
  end

  def invitation_token
    Invitation.new.send(:generate_token)
  end
end
