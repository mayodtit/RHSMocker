class Api::V1::SymptomsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only=>:index

  def index
    render_success symptoms:Symptom.all(:order=>:name)
  end

  def check

  end

end
