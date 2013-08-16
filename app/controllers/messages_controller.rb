class MessagesController < ApplicationController
  layout "console"
  before_filter :require_login

  def index
    @encounters = Encounter.open.order("created_at DESC")
    @user = current_user
    # render :layout=>"console"
    # render :view=>"index"
  end



end
