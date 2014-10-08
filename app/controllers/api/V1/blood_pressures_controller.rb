class Api::V1::BloodPressuresController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_blood_pressure!, only: %i(show update destroy)

  def index
    index_resource @user.blood_pressures.serializer
  end

  def show
    show_resource @blood_pressure.serializer
  end

  def create
    create_resource @user.blood_pressures, permitted_params.blood_pressure
  end

  def update
    update_resource @blood_pressure, permitted_params.blood_pressure
  end

  def destroy
    destroy_resource @blood_pressure
  end

  private

  def load_blood_pressure!
    @blood_pressure = @user.blood_pressures.find(params[:id])
    authorize! :manage, @blood_pressure
  end
end
