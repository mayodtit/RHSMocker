class Api::V1::BloodPressuresController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :diastolic, :systolic, :pulse, :user_id, :collection_type_id, :taken_at

  before_filter :load_user!
  before_filter :load_blood_pressure!, only: :destroy

  def index
    index_resource(@user.blood_pressures)
  end

  def show
    show_resource(@blood_pressure)
  end

  def create
    create_resource(@user.blood_pressures, sanitize_for_mass_assignment(params[:blood_pressure]))
  end

  def update
    update_resource(@blood_pressure, sanitize_for_mass_assignment(params[:blood_pressure]))
  end

  def destroy
    destroy_resource(@blood_pressure)
  end

  private

  def load_blood_pressure!
    @blood_pressure = @user.blood_pressures.find(params[:id])
    authorize! :manage, @blood_pressure
  end
end
