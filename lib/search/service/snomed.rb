require 'set'

class Search::Service::Snomed
  include HTTParty
  #TODO: version should be a changeable global variable set somewhere

  base_uri ENV['SNOMED_SEARCH_URL']

  def query(params)
    if params[:controller] == 'api/v1/allergies'
      allergy_flag  = true
    end
    #TODO simply a test, delete later
    if params[:q].blank?
      test_filter(params)
    end
    #END
    @skip_counter = 0
    query_params = select_query(allergy_flag, params)
    response = self.class.get('/descriptions', :query => query_params)
    raise StandardError, 'Non-success response from SNOMED database' unless response.success?
    sanitize_response(allergy_flag, response.parsed_response)
  end

  private

  #TESTING PURPOSES ONLY
  def test_filter(params)
    concept_set = Set.new
    concept_hash = Hash.new
    (0..34).each do |i|
      query_params = select_query(true, params)
      puts "#{query_params}"
      response = self.class.get('/descriptions', :query => query_params)
      @skip_counter += 100
      response['matches'].each do |match|
        unless allergy_filter(match)
          if concept_set.include?(match['conceptId'])
            puts "THERE ARE DUPLICATES #{i}, #{match['conceptId']}, #{match['term']} == #{concept_hash[match['conceptId']]}"
          else
            concept_set.add(match['conceptId'])
            concept_hash[match['conceptId']] = match['term']
          end
        end
      end
    end
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
    if term.include? '(' or term.include? 'allergy' or term.include? ' - '
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
