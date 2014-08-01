class Api::V1::RemoteEventsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    user = user()
    if Metadata.ignore_events_from_test_users? && user && user.test?
      render_success
    else
      create_resource RemoteEvent, remote_event_params(user)
    end
  end

  private

  def user
    params[:auth_token].present? ? Member.find_by_auth_token(params[:auth_token]) : current_user
  end

  def remote_event_params(user)
    {
      user: user,
      device_id: params[:properties] && params[:properties][:device_id],
      data: params.to_json
    }
  end
end
