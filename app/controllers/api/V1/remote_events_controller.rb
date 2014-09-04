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
    if params[:auth_token].present?
      Session.find_by_auth_token(params[:auth_token]).try(:member)
    else
      current_user
    end
  end

  def remote_event_params(user)
    {
      user: user,
      device_id: params[:properties] && params[:properties][:device_id],
      data: params.to_json
    }
  end
end
