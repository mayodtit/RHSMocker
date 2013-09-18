class Api::V1::SymptomsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only=>:index

  def index
    render_success symptoms:Symptom.all(:order=>:name)
    #Analytics.log_started_symptoms_checker(current_user.google_analytics_uuid)
  end

end
