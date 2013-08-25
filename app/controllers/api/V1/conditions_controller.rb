class Api::V1::ConditionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_conditions!

  def index
    index_resource(@conditions)
  end

  private

  def load_conditions!
    @conditions = params[:q] ? conditions_solr_query : Condition.order('name ASC')
  end

  def conditions_solr_query
    Condition.search do
      fulltext params[:q]
    end.results
  end
end
