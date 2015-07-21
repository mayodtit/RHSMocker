class Api::V1::SessionsController < Api::V1::ABaseController
  def destroy
    current_session.destroy
    uuid = current_user.google_analytics_uuid
    logout
    render_success
    Analytics.log_user_logout(uuid)
  end
end
