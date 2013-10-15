class HomeController < ApplicationController
  layout "console", :only=>:index
  
  def index
    @user = current_user
  end

  def faq
  end

  def blank
    head :ok
  end

end