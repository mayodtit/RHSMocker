class Api::V1::RemoteEventsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    create_resource(RemoteEvent, remote_event_params)
  end

  private

  def remote_event_params
    user = params[:auth_token].present? ? Member.find_by_auth_token(params[:auth_token]) : current_user
    {
      user: user,
      device_id: params[:properties][:device_id],
      data: params.to_json
    }
  end
end
