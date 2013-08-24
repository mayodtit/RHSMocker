class Api::V1::DiseasesController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_diseases!

  def index
    index_resource(@diseases)
  end

  private

  def load_diseases!
    @diseases = params[:q] ? diseases_solr_query : Disease.order('name ASC')
  end

  def diseases_solr_query
    Disease.search do
      fulltext params[:q]
    end.results
  end
end
