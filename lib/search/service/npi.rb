class Search::Service::Npi
  include HTTParty
  base_uri 'http://docnpi.com'

  def query(search_params)
    self.class.get('/api/index.php', :query => search_params.merge(:format => :json))
              .parsed_response
  end

  def find(params)
    id = params[:npi_number]
    self.class.get('/api/index.php', :query => {:ident => id,
                                                :is_ident => true,
                                                :format => :json})
              .parsed_response
  end
end
