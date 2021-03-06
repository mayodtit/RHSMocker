module SolrExtensionModule
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_reindex
    attr_accessible :skip_reindex
    after_commit :reindex, unless: :skip_reindex
  end

  module ClassMethods
    def or_search(param)
      search do
        adjust_solr_params do |solr_params|
          solr_params[:q] = sanitize_solr_query(param)
          solr_params[:qf] = 'name_text'
          solr_params[:defType] = 'dismax'
          solr_params[:mm] = 1
        end
      end
    end

    def sanitize_solr_query(query)
      query.gsub(/[-+]/, ' ')
    end
  end

  def reindex
    self.class.reindex
    Sunspot.commit
  end
end
