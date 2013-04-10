class HomeController < ApplicationController
  layout "console"
  
  def index
    @user = current_user
  end

end