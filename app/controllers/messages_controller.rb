class MessagesController < ApplicationController
  layout "console"
  before_filter :require_login_from_http_basic

  def index
    @encounters = Encounter.all
    @user = current_user
    # render :layout=>"console"
    # render :view=>"index"
  end



end