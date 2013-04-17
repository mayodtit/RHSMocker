class MessagesController < ApplicationController
  layout "console"
  before_filter :require_login
  load_and_authorize_resource

  def index
    @encounters = Encounter.open
    @user = current_user
    # render :layout=>"console"
    # render :view=>"index"
  end



end