class Api::V1::SideEffectsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_search_variables, :only => :index

  def index
    side_effects = @query ? solr_query : sql_query
    render_success({side_effects:side_effects})
  end

  private

  def load_search_variables
    @treatment_id = params[:treatment_id]
    @query = params[:q]
  end

  def solr_query
    if @treatment_id
      query = @query
      treatment_id = @treatment_id.to_i
      TreatmentSideEffect.search do
        fulltext query
        with :treatment_id, treatment_id
      end.map(&:side_effect)
    else
      query = @query
      SideEffect.search do
        fulltext query
      end
    end
  end

  def sql_query
    @treatment_id ? SideEffect.for_treatment(@treatment_id) : SideEffect.all
  end
end
