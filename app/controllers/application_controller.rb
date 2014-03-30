class ApplicationController < ActionController::Base
  protect_from_forgery

  def permitted_params(subject=nil)
    @permitted_params ||= PermittedParams.new(params, current_user, subject || @user)
  end
end
