class Api::V1::UserLocationsController < Api::V1::ABaseController
  def create
    UserLocation.create(longitude:params[:longitude], latitude:params[:latitude], user:current_user)
    render_success
  end
end