class Api::V1::PhoneCallSummariesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_phone_call_summary!

  def show
    show_resource(merge_body(@phone_call_summary))
  end

  private

  def load_phone_call_summary!
    @phone_call_summary = PhoneCallSummary.find(params[:id])
    authorize! :manage, @phone_call_summary
  end

  def merge_body(phone_call_summary)
    phone_call_summary.as_json.merge!(:body => render_to_string(:action => :show,
                                                                :formats => [:html],
                                                                :locals => {:phone_call_summary => phone_call_summary}))
  end
end
