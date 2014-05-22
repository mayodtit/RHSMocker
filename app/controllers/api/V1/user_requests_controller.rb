# TODO - this controller does not use resource helpers because of serializer embedding
class Api::V1::UserRequestsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_requests!
  before_filter :load_user_request!, only: %i(show update)

  def index
    render_success(@user_requests.serializer(root: :user_requests).as_json)
  end

  def show
    render_success(@user_request.serializer.as_json)
  end

  def create
    @user_request = @user_requests.create(user_request_attributes)
    if @user_request.errors.empty?
      render_success(@user_request.serializer.as_json)
    else
      render_failure({reason: @user_request.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @user_request.update_attributes(user_request_attributes)
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

  def user_request_attributes
    params.require(:user_request).permit(:user_id,
                                         :subject_id,
                                         :name,
                                         :user_request_type_id)
  end
end
