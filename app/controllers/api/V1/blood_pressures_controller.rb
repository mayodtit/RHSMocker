class Api::V1::BloodPressuresController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_blood_pressure!, only: :destroy

  def index
    render_success(blood_pressures: @user.blood_pressures)
  end

  def create
    @blood_pressure = @user.blood_pressures.create(params[:blood_pressure])
    if @blood_pressure.errors.empty?
      render_success(blood_pressure: @blood_pressure)
    else
      render_failure({reason: @blood_pressure.errors.full_messages.to_sentence}, 412)
    end
  end

  def destroy
    if @blood_pressure.destroy
      render_success
    else
      render_failure({reason: @blood_pressure.errors.full_messages.to_sentence}, 422)
    end
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
