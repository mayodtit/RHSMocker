class MessagesController < ApplicationController
  layout "console"
  before_filter :require_login

  def index
    @consults = Consult.open.order("created_at DESC")
    @user = current_user
    # render :layout=>"console"
    # render :view=>"index"
  end



end
