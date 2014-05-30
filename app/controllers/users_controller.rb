class UsersController < ApplicationController
  layout 'public_page_layout'

  before_filter :load_referral_code!, only: :signup_create
  before_filter :load_onboarding_group!, only: :signup_create
  before_filter :load_token!, only: %i(reset_password reset_password_update)
  before_filter :load_user!, only: %i(reset_password reset_password_update)

  def signup
    @code = params[:code]
  end

  def signup_create
    @member = Member.create(create_attributes)
    if @member.errors.empty?
      redirect_to complete_invites_url
    else
      render action: :signup
    end
  end

  def reset_password
  end

  def reset_password_update
    if @user.update_attributes(password: params[:member][:password], skip_agreement_validation: true)
      @user.reset_password_token = nil
      @user.save
      render :reset_password_success
    else
      render :reset_password
    end
  end

  private

  def load_token!
    render :reset_password_expired unless params[:token].present?
    @token = params[:token]
  end

  def load_user!
    @user = Member.find_by_reset_password_token(@token)
    render :reset_password_expired unless @user
  end

  def load_referral_code!
    @referral_code = ReferralCode.find_by_code(params.require(:user)[:code]) if params.require(:user)[:code]
  end

  def load_onboarding_group!
    @onboarding_group = @referral_code.try(:onboarding_group)
  end

  def create_attributes
    permitted_params.user.tap do |attributes|
      attributes[:onboarding_group] = @onboarding_group if @onboarding_group
    end
  end
end
