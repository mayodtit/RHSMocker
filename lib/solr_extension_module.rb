module SolrExtensionModule
  extend ActiveSupport::Concern

  module ClassMethods
    def or_search(param)
      search do
        adjust_solr_params do |solr_params|
          solr_params[:q] = param
          solr_params[:qf] = 'name_text'
          solr_params[:defType] = 'dismax'
          solr_params[:mm] = 1
        end
      end
    end
  end
end
