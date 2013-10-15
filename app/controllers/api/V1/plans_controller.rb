class Api::V1::PlansController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_user!
  before_filter :load_plans!

  def index
    index_resource(@plans.active_model_serializer_instance)
  end

  private

  def load_plans!
    @plans = Plan.all
  end
end
