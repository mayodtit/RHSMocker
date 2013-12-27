class Api::V1::FactorGroupsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptom!
  before_filter :load_factor_groups!

  def index
    index_resource @factor_groups.serializer
  end

  private

  def load_symptom!
    @symptom = Symptom.find(params[:symptom_id])
  end

  def load_factor_groups!
    @factor_groups = @symptom.factor_groups.order(:ordinal)
  end
end
