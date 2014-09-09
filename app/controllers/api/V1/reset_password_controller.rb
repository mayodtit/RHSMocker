class Api::V1::ResetPasswordController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_user_from_email!, only: :create
  before_filter :load_user_from_token!, only: [:show, :update]

  def create
    if @user.signed_up?
      @user.deliver_reset_password_instructions!
    else
      @user.hacky_simple_invite!
    end
    render_success
  end

  def show
    render_success
  end

  def update
    if @user.change_password!(params[:password])
      render_success
    else
      render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_user_from_email!
    @user = Member.find_by_email(params[:email])
    raise ActiveRecord::RecordNotFound, 'We could not find an account with that email address. If this is an error, please contact support@getbetter.com' if @user.nil?
  end

  def load_user_from_token!
    raise ActiveRecord::RecordNotFound, 'We could not find an account. if this is an error, please contact support@getbetter.com' unless params[:id].present?
    @user = Member.find_by_reset_password_token!(params[:id])
  end
end
