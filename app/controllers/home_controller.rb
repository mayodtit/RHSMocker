class HomeController < ApplicationController
  layout "console"
  
  def index
  end

  def logout_user
  	logout
  	redirect_to root_path
  end
end