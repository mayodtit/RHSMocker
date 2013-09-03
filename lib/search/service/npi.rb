class Search::Service::Npi
  include HTTParty
  base_uri 'http://api.notonlydev.com/'

  def query(params)
    sanitize_response(get_records(params))
  end

  def find(params)
    response = get_records(params)
    unless response[params[:npi_number]]
      raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}"
    end
    sanitize_record(response[params[:npi_number]])
  end

  private

  def get_records(params)
    response = self.class.get('/api/index.php', :query => params.merge(:apikey => ENV['NOD_API_KEY'],
                                                                       :is_person => true,
                                                                       :is_address => false,
                                                                       :is_org => false,
                                                                       :is_ident => false,
                                                                       :format => :json))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    response.parsed_response
  end

  def sanitize_response(response)
    return response if response.empty?
    response.values.map do |user|
      sanitize_record(user)
    end
  end

  def sanitize_record(user)
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
