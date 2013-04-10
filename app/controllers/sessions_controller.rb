class SessionsController < ApplicationController  
  layout "console"

  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      redirect_to login_path, :alert => "Email or password was invalid."
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
