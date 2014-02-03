class Api::V1::AssociatesController < Api::V1::UsersController
  skip_before_filter :load_user! # skip base class
  skip_before_filter :convert_parameters! # skip base class
  before_filter :load_user!
  before_filter :load_associate!, only: [:show, :update, :destroy]
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    index_resource @user.associates, name: :users
  end

  def show
    show_resource @associate, name: :user
  end

  def create
    create_resource @user.associates, associate_attributes, name: :user
  end

  def update
    update_resource @associate, associate_attributes, name: :user
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

  def associate_attributes
    base_attributes
  end
end
