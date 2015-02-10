require 'set'

class Search::Service::Snomed
  include HTTParty
  base_uri ENV['SNOMED_SEARCH_URL']

  def query(params)
    @skip_counter = 0
    if params[:controller] == 'api/v1/allergies'
      allergy_flag  = true
    end
    query_params = select_query(allergy_flag, params)
    response = self.class.get('/descriptions', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(allergy_flag, response.parsed_response)
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

  def select_query(allergy_flag, params)
    if allergy_flag
      allergy_query(params)
    else
      condition_query(params)
    end
  end

  def allergy_query(params)
    "query=#{params[:q]}%20allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=#{@skip_counter}&returnLimit=100&semanticFilter=disorder&normalize=true"
  end

  def condition_query(params)
    "query=#{params[:q]}&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=#{@skip_counter}&returnLimit=100&normalize=true"
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
      term = match['term']
      unless allergy_filter(term)
        result << {
          :environmental_allergen => false,
          :food_allergen => false,
          :medication_allergen => false,
          :name => term,
          :snomed_code => match['conceptId'],
          :snomed_name => match['fsn'],
          :concept_id => match['conceptId'],
          :description_id =>match['descriptionId']
        }
      end
    end
    result
  end

  def sanitize_condition(response)
    result = []
    response['matches'].each do |match|
      term = match['term']
      unless condition_filter(term)
        result << {
            :name => term,
            :snomed_code => match['conceptId'],
            :snomed_name => match['fsn'],
            :concept_id => match['conceptId'],
            :description_id =>match['descriptionId']
        }
      end
    end
    result
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
