require 'set'

class Search::Service::Snomed
  include HTTParty
  base_uri ENV['SNOMED_SEARCH_URL']

  def query(params)
    @skip_counter = 0
    if params[:controller] == 'api/v1/allergies'
      is_allergy  = true
    end
    query_params = select_query(is_allergy, params)
    response = self.class.get('/descriptions', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(is_allergy, response.parsed_response)
  end

  private

  #Used to test the accuracy of the allergy filter.  Pass in empty params.
  def test_filter(params)
    concept_set = Set.new
    concept_hash = Hash.new
    @skip_counter = 0
    (0..34).each do |i|
      query_params = select_query(true, params)
      puts "#{query_params}"
      response = self.class.get('/descriptions', :query => query_params)
      @skip_counter += 100
      response['matches'].each do |match|
        term = match['term']
        unless allergy_filter(term)
          if concept_set.include?(match['conceptId'])
            puts "#{match['conceptId']}, #{term} == #{concept_hash[match['conceptId']]}"
          else
            concept_set.add(match['conceptId'])
            concept_hash[match['conceptId']] = term
          end
        end
      end
    end
    puts concept_set.size
  end

  def select_query(is_allergy, params)
    if is_allergy
      allergy_query(params)
    else
      condition_query(params)
    end
  end

  def allergy_query(params)
    "query=#{params[:q].gsub(' ', '%20')}%20allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=#{@skip_counter}&returnLimit=100&semanticFilter=disorder&normalize=true"
  end

  def condition_query(params)
    "query=#{params[:q].gsub(' ', '%20')}&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=#{@skip_counter}&returnLimit=100&normalize=true"
  end

  def sanitize_response(is_allergy, response)
    if is_allergy
      sanitize_allergy(response)
    else
      sanitize_condition(response)
    end
  end

  def sanitize_allergy(response)
    result = []
    response['matches'].each do |match|
      term = match['term']
      unless allergy_filter(term)
        current_result = {
            :environmental_allergen => false,
            :food_allergen => false,
            :medication_allergen => false}
        result << set_result(current_result, match)
      end
    end
    result
  end

  def sanitize_condition(response)
    result = []
    response['matches'].each do |match|
      unless condition_filter(match['term'])
        current_result = Hash.new
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
