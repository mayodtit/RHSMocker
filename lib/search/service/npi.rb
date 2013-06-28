class Search::Service::Npi
  include HTTParty
  base_uri 'http://docnpi.com'

  def query(search_params)
    response = self.class.get('/api/index.php', :query => search_params.merge(:taxonomy => 'group_1',
                                                                              :format => :json))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def find(params)
    id = params[:npi_number]
    result = query({:ident => id, :is_ident => true})[0]
    raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}" unless result
    result
  end

  private

  def sanitize_response(response)
    return response if response.empty?
    response.values.map do |user|
      {
        :first_name => user['first_name'].titleize(:underscore => false, :humanize => false),
        :last_name => user['last_name'].titleize(:underscore => false, :humanize => false),
        :npi_number => user['npi'],
        :city => user['city'].titleize(:underscore => false, :humanize => false),
        :state => user['state'],
        :expertise => user['description']
      }
    end
  end
end
