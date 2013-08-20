class Api::V1::UserDiseaseUserTreatmentsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_disease_and_treatment!
  before_filter :load_user_disease_user_treatment!, only: :destroy

  def create
    create_resource(UserDiseaseUserTreatment, attributes_for_create)
  end

  def destroy
    destroy_resource(@user_disease_user_treatment)
  end

  private

  def load_disease_and_treatment!
    if params[:disease_id]
      @user_disease = @user.user_diseases.find(params[:disease_id])
      @user_treatment = @user.user_treatments.find(params[:id])
    else params[:treatment_id]
      @user_treatment = @user.user_treatments.find(params[:treatment_id])
      @user_disease = @user.user_diseases.find(params[:id])
    end
    authorize! :manage, @user_disease
    authorize! :manage, @user_treatment
  end

  def load_user_disease_user_treatment!
    @user_disease_user_treatment = UserDiseaseUserTreatment.where(:user_disease_id => @user_disease.id,
                                                                  :user_treatment_id => @user_treatment.id).first!
  end

  def attributes_for_create
    {
      user_disease: @user_disease,
      user_treatment: @user_treatment
    }
  end
end
