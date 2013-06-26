class Search::Service::Npi
  include HTTParty
  base_uri 'http://docnpi.com'

  def query(search_params)
    response = self.class.get('/api/index.php', :query => search_params.merge(:format => :json))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def find(params)
    id = params[:npi_number]
    query({:ident => id, :is_itent => true})[0]
  end

  private

  def sanitize_response(response)
    response.values.map do |user|
      {
        :first_name => user['first_name'],
        :last_name => user['last_name'],
        :npi_number => user['npi'],
        :city => user['city'],
        :state => user['state'],
        :expertise => user['description']
      }
    end
  end
end
