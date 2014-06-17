# TODO - this controller does not use resource helpers because of serializer embedding
class Api::V1::UserRequestsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_requests!
  before_filter :load_user_request!, only: %i(show update)
  before_filter :convert_parameters!, only: :create

  def index
    render_success(@user_requests.serializer(root: :user_requests).as_json)
  end

  def show
    render_success(@user_request.serializer.as_json)
  end

  def create
    @user_request = @user_requests.create(permitted_params.user_request)
    if @user_request.errors.empty?
      render_success(@user_request.serializer.as_json)
    else
      render_failure({reason: @user_request.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @user_request.update_attributes(permitted_params.user_request)
      render_success(@user_request.serializer.as_json)
    else
      render_failure({reason: @user_request.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_user_requests!
    @user_requests = @user.user_requests
  end

  def load_user_request!
    @user_request = @user_requests.find(params[:id])
  end

  def convert_parameters!
    if request.env['PATH_INFO'].include?('appointment_request')
      params.require(:user_request)[:user_request_type_id] = UserRequestType.appointment.try(:id)
    end
  end
end
