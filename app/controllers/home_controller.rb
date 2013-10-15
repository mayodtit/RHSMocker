class HomeController < ApplicationController
  layout "console", :only=>:index
  
  def index
    #@user = current_user
    render nothing: true
  end

  def faq
  end

end