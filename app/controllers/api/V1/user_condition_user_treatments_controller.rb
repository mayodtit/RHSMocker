class Api::V1::UserConditionUserTreatmentsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_condition!
  before_filter :load_treatment!
  before_filter :load_user_condition_user_treatment!, only: :destroy

  def create
    create_resource(UserConditionUserTreatment, attributes_for_create, name: :user_disease_user_treatment) and return if disease_path?
    create_resource UserConditionUserTreatment, attributes_for_create
  end

  def destroy
    destroy_resource @user_condition_user_treatment
  end

  private

  def load_condition!
    @user_condition = @user.user_conditions.find(params[:condition_id] || params[:disease_id] || params[:id])
    authorize! :manage, @user_condition
  end

  def load_treatment!
    @user_treatment = @user.user_treatments.find(params[:treatment_id] || params[:id])
    authorize! :manage, @user_treatment
  end

  def load_user_condition_user_treatment!
    @user_condition_user_treatment = UserConditionUserTreatment.where(:user_condition_id => @user_condition.id,
                                                                      :user_treatment_id => @user_treatment.id).first!
  end

  def attributes_for_create
    {
      user_condition: @user_condition,
      user_treatment: @user_treatment
    }
  end

  def disease_path?
    request.env['PATH_INFO'].include?('disease')
  end
end
