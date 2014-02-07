class Api::V1::AssociatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associate!, only: [:show, :update, :destroy]
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    index_resource @user.associates.serializer, name: :users
  end

  def show
    show_resource @associate.serializer, name: :user
  end

  def create
    create_resource @user.associates,
                    permitted_params(@associate).user,
                    name: :user
  end

  def update
    update_resource @associate,
                    permitted_params(@associate).user,
                    name: :user
  end

  def destroy
    destroy_resource @associate
  end

  private

  def load_user!
    @user = User.find(params[:user_id])
    authorize! :manage, @user
  end

  def load_associate!
    @associate = @user.associates.find(params[:id])
    authorize! :manage, @associate
  end

  def convert_parameters!
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar]
  end
end
