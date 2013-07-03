class Api::V1::BloodPressuresController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_blood_pressure!, only: :destroy

  def index
    index_resource(@user.blood_pressures)
  end

  def show
    show_resource(@blood_pressure)
  end

  def create
    create_resource(@user.blood_pressures, params[:blood_pressure])
  end

  def update
    update_resource(@blood_pressure, params[:blood_pressure])
  end

  def destroy
    destroy_resource(@blood_pressure)
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_blood_pressure!
    @blood_pressure = BloodPressure.find(params[:id])
    authorize! :manage, @blood_pressure
  end
end
