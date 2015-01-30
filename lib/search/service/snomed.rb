require 'set'

class Search::Service::Snomed
  include HTTParty
  #TODO: version should be a changeable global variable set somewhere
  base_uri 'http://127.0.0.1:4000/snomed/en-edition/v20140901'

  def query(params)
    if params[:controller] == 'api/v1/allergies'
      allergy_flag  = true
    end
    query_params = select_query(allergy_flag, params)
    response = self.class.get('/descriptions', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(allergy_flag, response.parsed_response)
  end

  private

  def select_query(allergy_flag, params)
    if allergy_flag
      allergy_query(params)
    else
      condition_query(params)
    end
  end

  def allergy_query(params)
    "query=#{params[:q]}%20allergy&searchMode=partialMatching&semanticFilter=disorder"
  end

  def condition_query(params)
    "query=#{params[:q]}&searchMode=partialMatching&semanticFilter=disorder"
  end

  def sanitize_response(allergy_flag, response)
    if allergy_flag
      sanitize_allergy(response)
    else
      sanitize_condition(response)
    end
  end

  def sanitize_allergy(response)
    result = []
    response['matches'].each do |match|
      unless allergy_filter(match)
        result << {
          :environmental_allergen => false,
          :food_allergen => false,
          :medication_allergen => false,
          :name => match['term'],
          :snomed_code => match['conceptId'],
          :snomed_name => match['fsn']
        }
      end
    end
    result
  end

  def sanitize_condition(response)
    result = []
    response['matches'].each do |match|
      unless condition_filter(match)
        result << {
            :name => match['term'],
            :snomed_code => match['conceptId'],
            :snomed_name => match['fsn']
        }
      end
    end

    result
  end

  def condition_filter(match)
    term = match['term']
    if allergy_filter(match) or term.include? 'allergy' or term.include? ' of ' or term.include? ' - ' or term =~ /\d/
      true
    else
      false
    end
  end

  def allergy_filter(match)
    term = match['term']
    if term.include? '(' or term.include? 'Allergy to'
      true
    else
      false
    end
  end
end
