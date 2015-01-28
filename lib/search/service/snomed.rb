class Search::Service::Snomed
  include HTTParty
  #TODO: version should be a changeable global variable set somewhere
  base_uri 'http://127.0.0.1:4000/snomed/en-edition/v20140901/'

  def query(params)
    byebug
    query_params = select_query(params)
    response = self.class.get('/concepts/' + query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def select_query(params)
    if params[:controller] == 'api/v1/allergies'
      new_params = allergy_query(params)
    else
      new_params = condition_query(params)
    end
    new_params
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
