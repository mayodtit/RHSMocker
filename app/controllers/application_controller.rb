class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied!"
    redirect_to root_url
  end

  private 

  def not_authenticated
    redirect_to login_url, :notice => "First log in to view this page."
  end
end
