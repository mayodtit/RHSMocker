class Api::V1::ConditionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_conditions!, only: [:index]
  
  def index
    index_resource(@conditions.serializer, name: :diseases) and return if diseases_path?
    index_resource(@conditions.serializer)
  end

  def search
    begin
      @conditions = params[:q].blank? ? Condition.order('name ASC') : snomed_results
    rescue => e
      render_failure({reason: e.message}, 502)
      return
    end
    index_resource(@conditions.serializer, name: :diseases) and return if diseases_path?
    index_resource(@conditions.serializer)
  end

  private

  def snomed_results
    search_service.snomed_query(params)
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def load_conditions!
    @conditions = params[:q].blank? ? Condition.order('name ASC') : solr_results.results
  end

  def solr_results
    Condition.or_search(params[:q])
  end

  def diseases_path?
    request.env['PATH_INFO'].include?('disease')
  end
end
