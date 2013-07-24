class Api::V1::UserDiseaseTreatmentsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :user_id, :treatment_id, :user_disease_id, :amount, :amount_unit, :doctor_user_id,
                  :end_date, :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration,
                  :time_duration_unit

  before_filter :load_user!
  before_filter :load_user_disease_treatment!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_disease_treatments)
  end

  def show
    show_resource(@user_disease_treatment)
  end

  def create
    create_resource(@user.user_disease_treatments, sanitize_for_mass_assignment(params[:user_disease_treatment]))
  end

  def update
    update_resource(@user_disease_treatment, sanitize_for_mass_assignment(params[:user_disease_treatment]))
  end

  def destroy
    destroy_resource(@user_disease_treatment)
  end

  private

  def load_user_disease_treatment!
    @user_disease_treatment = @user.user_disease_treatments.find(params[:id])
    authorize! :manage, @user_disease_treatment
  end
end
