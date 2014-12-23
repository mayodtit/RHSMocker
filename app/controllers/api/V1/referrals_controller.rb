class Api::V1::ReferralsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_referral_code
  before_filter :load_onboarding_group
  before_filter :load_users!
  before_filter :load_user

  def create
    if @user && !@user.is_premium? && @user.onboarding_group.nil? && @onboarding_group
      @user.update_attributes(update_attributes)
    else
      @user = @users.create(create_attributes)
      if @user.errors.empty?
        Mails::InvitationJob.create(@user.id, invite_url(@user.invitation_token))
      end
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

  def load_user
    @user = Member.find_by_email(params[:email])
  end

  def create_attributes
    params.permit(:email).tap do |attributes|
      attributes[:referral_code] = @referral_code if @referral_code
      attributes[:invitation_token] = invitation_token
    end
  end

  def update_attributes
    #TODO - move logic to model
    {}.tap do |attributes|
      attributes[:referral_code] = @referral_code if @referral_code
      attributes[:onboarding_group] = @onboarding_group if @onboarding_group
      attributes[:is_premium] = @onboarding_group.try(:premium)
      attributes[:free_trial_ends_at] = @onboarding_group.try(:free_trial_ends_at)
    end
  end

  def invitation_token
    Invitation.new.send(:generate_token)
  end
end
