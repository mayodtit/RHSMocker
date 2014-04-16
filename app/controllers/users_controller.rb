class UsersController < ApplicationController
  layout 'public_page_layout'

  before_filter :load_token!
  before_filter :load_user!

  def reset_password
  end

  def reset_password_update
    @user.password_confirmation = params[:member][:password_confirmation]
    if @user.change_password!(params[:member][:password])
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
end
