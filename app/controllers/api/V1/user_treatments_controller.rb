class Api::V1::UserTreatmentsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :user_id, :treatment_id, :user_condition_id, :amount, :amount_unit, :doctor_id,
                  :end_date, :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration,
                  :time_duration_unit, :user_condition_ids, :user_disease_ids

  before_filter :load_user!
  before_filter :load_user_treatment!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_treatments, :user_disease_treatments)
  end

  def show
    show_resource(@user_treatment, :user_disease_treatment)
  end

  def create
    create_resource(@user.user_treatments, sanitize_for_mass_assignment(user_treatment_params), :user_disease_treatment)
  end

  def update
    update_resource(@user_treatment, sanitize_for_mass_assignment(user_treatment_params), :user_disease_treatment)
  end

  def destroy
    destroy_resource(@user_treatment)
  end

  private

  def load_user_treatment!
    @user_treatment = @user.user_treatments.find(params[:id])
    authorize! :manage, @user_treatment
  end

  def user_treatment_params
    (params[:user_treatment].try_method(:any?) ? params[:user_treatment] : params[:user_disease_treatment]) || {}
  end
end
