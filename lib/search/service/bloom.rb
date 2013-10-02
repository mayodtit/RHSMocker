class Search::Service::Bloom
  include HTTParty
  base_uri 'http://www.bloomapi.com/'

  def query(params)
    response = self.class.get('/api/search', :query => query_params(params))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def find(params)
    response = self.class.get('/api/search', :query => query_params(:npi => params[:npi_number]))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    unless response['result'].count > 0
      raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}"
    end
    sanitize_record(response['result'].first)
  end

  private

  QUERY_PARAMS = [:first_name, :last_name, :npi]

  def sanitize_params(params)
    new_params = params.reject{|k,v| !QUERY_PARAMS.include?(k.to_sym)}
    new_params['practice_address.state'] = params[:state] if params[:state]
    new_params
  end

  def query_params(params)
    params = sanitize_params(params)
    result = []
    params.keys.each_with_index do |key, i|
      result << "key#{i}=#{key.to_s}&op#{i}=eq&value#{i}=#{params[key].to_s.upcase}"
    end
    result.join('&')
  end

  def sanitize_response(response)
    response['result'].map do |record|
      sanitize_record(record)
    end
  end

  def sanitize_record(record)
    {
      :first_name => record['first_name'].titleize(:underscore => false, :humanize => false),
      :last_name => record['last_name'].titleize(:underscore => false, :humanize => false),
      :npi_number => record['npi'].to_s,
      :city => record['practice_address']['city'].titleize(:underscore => false, :humanize => false),
      :state => record['practice_address']['state'],
      :expertise => record['credential']
    }
  end
end
