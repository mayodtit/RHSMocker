class Api::V1::SymptomsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptoms!
  after_filter :log_analytics!

  def index
    index_resource @symptoms.serializer
  end

  private

  def load_symptoms!
    @symptoms = Symptom.order(:name)
                       .includes(:symptom_medical_advices => :symptom_medical_advice_items,
                                 :symptom_selfcare => :symptom_selfcare_items)
  end

  def log_analytics!
    Analytics.log_started_symptoms_checker(current_user.google_analytics_uuid) if current_user
  end
end
