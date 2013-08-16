class Api::V1::LocationsController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    create_resource(@user.locations, params[:location])
  end
end
