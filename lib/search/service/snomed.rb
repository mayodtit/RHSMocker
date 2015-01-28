class Search::Service::Snomed
  include HTTParty
  #TODO: version should be a changeable global variable set somewhere
  base_uri 'http://127.0.0.1:4000/snomed/en-edition/v20140901/'

  def query(params)
    if params[:controller] == 'api/v1/allergies'
      query_params = allergy_query(params)
    else
      query_params = condition_query(params)
    end
    byebug
    response = self.class.get('/concepts', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def allergy_query(params)
    params[:q] = 'dog'
    result = '91936005'
    result
  end

  def condition_query(params)

  end

  def sanitize_response(response)

  end
end
