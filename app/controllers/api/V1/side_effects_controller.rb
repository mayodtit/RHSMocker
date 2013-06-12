class Api::V1::SideEffectsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    side_effects = params[:treatment_id] ? SideEffect.for_treatment(params[:treatment_id]) : SideEffect.all
    render_success({side_effects:side_effects})
  end
end
