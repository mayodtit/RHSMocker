require 'set'

class Search::Service::Snomed
  include HTTParty
  base_uri ENV['SNOMED_SEARCH_URL']

  def query(params)
    if params[:controller] == 'api/v1/allergies'
      is_allergy  = true
    elsif params[:controller] == 'api/v1/conditions'
      @semanticFilter = 'disorder'
    end
    query_params = select_query(is_allergy, params)
    response = self.class.get('/descriptions', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(is_allergy, response.parsed_response)
  end

  private

  def select_query(is_allergy, params)
    is_allergy ? allergy_query(params) : condition_query(params)
  end

  def allergy_query(params)
    "query=#{params[:q].gsub(' ', '%20')}%20allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=0&returnLimit=100&semanticFilter=disorder&normalize=true"
  end

  def condition_query(params)
    "query=#{params[:q].gsub(' ', '%20')}&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=0&returnLimit=100&normalize=true&semanticFilter=#{@semanticFilter}"
  end

  def sanitize_response(is_allergy, response)
    is_allergy ? sanitize_allergy(response) : sanitize_condition(response)
  end

  def sanitize_allergy(response)
    result = []
    response['matches'].each do |match|
      term = match['term']
      unless allergy_filter(term)
        current_result = {
            environmental_allergen: nil,
            food_allergen: nil,
            medication_allergen: nil}
        result << set_result(current_result, match)
      end
    end
    result
  end

  def sanitize_condition(response)
    result = []
    response['matches'].each do |match|
      unless condition_filter(match['term'])
        current_result = {}
        result << set_result(current_result, match)
      end
    end
    result
  end

  def set_result(current_result, match)
    current_result[:name] = match['term']
    current_result[:snomed_code] = match['conceptId']
    current_result[:snomed_name] = match['fsn']
    current_result[:concept_id] = match['conceptId']
    current_result[:description_id] = match['descriptionId']
    current_result
  end

  def condition_filter(term)
    if term.include? '(disorder)' or term.include? 'allergy' or term.include? ' - '
      true
    else
      false
    end
  end

  def allergy_filter(term)
    if term.include? '(disorder)'
      true
    else
      false
    end
  end
end
