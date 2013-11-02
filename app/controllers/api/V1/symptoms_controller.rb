class Api::V1::SymptomsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only=>:index

  def index
    render_success symptoms:Symptom.order(:name).as_json(:include => {:symptom_selfcare => {:include => :symptom_selfcare_items}})
    Analytics.log_started_symptoms_checker(current_user.google_analytics_uuid) if current_user
  end

end
