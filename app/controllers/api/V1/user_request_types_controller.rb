class Api::V1::UserRequestTypesController < Api::V1::ABaseController
  before_filter :load_user_request_types!
  before_filter :load_user_request_type!, only: %i(show update)

  def index
    index_resource @user_request_types.serializer
  end

  def show
    show_resource @user_request_type.serializer
  end

  def create
    authorize! :create, UserRequestType
    create_resource @user_request_types, user_request_type_attributes
  end

  def update
    authorize! :update, @user_request_type
    update_resource @user_request_type, user_request_type_attributes
  end

  private

  def load_user_request_types!
    @user_request_types = UserRequestType.scoped
  end

  def load_user_request_type!
    @user_request_type = @user_request_types.find(params[:id])
  end

  def user_request_type_attributes
    params.require(:user_request_type).permit(:name)
  end
end
