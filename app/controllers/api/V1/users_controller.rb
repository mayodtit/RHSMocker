class Api::V1::UsersController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :convert_parameters!, only: [:update]

  def show
    show_resource @user
  end

  def update
    update_resource @user, user_attributes
  end

  protected

  def load_user!
    @user = User.find_by_id(params[:id]) || current_user
    authorize! :manage, @user
  end

  def convert_parameters!
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar]
  end

  def base_attributes
    params.require(:user).permit(:first_name, :last_name, :avatar, :gender,
                                 :height, :birth_date, :phone, :blood_type,
                                 :holds_phone_in, :diet_id, :ethnic_group_id,
                                 :deceased, :date_of_death, :npi_number,
                                 :expertise, :city, :state, :units, :nickname,
                                 :work_phone_number)
  end

  def user_attributes
    base_attributes.tap do |attributes|
      attributes.merge!(params.require(:user).permit(:email)) if current_user != @user
      attributes.merge!(client_data: client_data_params) if client_data_params
    end
  end

  def client_data_params
    params.require(:user)[:client_data]
  end
end
