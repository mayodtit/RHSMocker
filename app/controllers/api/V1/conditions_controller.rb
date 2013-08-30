class Api::V1::ConditionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_conditions!

  def index
    index_resource(@conditions, :diseases) and return if diseases_path?
    index_resource(@conditions)
  end

  private

  def load_conditions!
    @conditions = params[:q].blank? ? Condition.order('name ASC') : solr_results
  end

  def solr_results
    Condition.search{ fulltext params[:q] }
  end

  def diseases_path?
    request.env['PATH_INFO'].include?('disease')
  end
end
