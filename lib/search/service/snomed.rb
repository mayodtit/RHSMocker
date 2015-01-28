# Code values explained here (in case you ever need some light bedtime reading)
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/downloads/Data_Dissemination_File-Code_Values.pdf

class Search::Service::Snomed
  include HTTParty
  #TODO: version should be a changeable global variable set somewhere
  base_uri 'http://107.170.143.181/api/snomed/en-edition/v20140731/'

  def query(params)
    byebug
    if params[:controller] == 'api/v1/allergies'
      query_params = allergy_query(params)
    else
      query_params = condition_query(params)
    end
    response = self.class.get('/api/search', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def allergy_query(params)
    params[:q] = 'dog'
  end

  def condition_query(params)

  end
end
