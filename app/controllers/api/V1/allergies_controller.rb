class Api::V1::AllergiesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  # deprecated - please use #search instead
  def index
    @allergies = if params[:q].blank?
      Allergy.where('snomed_code NOT in (?)', excluded_allergies).order('name ASC')
    else
      solr_results.reject{|a| excluded_allergies.include?(a.snomed_code) }
    end
    render_success({allergies: @allergies})
  end

  def search
    @allergies = if params[:q].blank?
      Allergy.where('snomed_code NOT in (?)', excluded_allergies).order('name ASC')
    else
      snomod_results.reject{|a| excluded_allergies.include?(a.snomed_code) }
    end

    render_success({allergies: @allergies})
  end

  private

  def solr_results
    Allergy.or_search(params[:q]).results
  end

  def snomod_results
    begin
      search_service.snomed_query(params)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  # array of snomed codes that we don't want to appear in results
  def excluded_allergies
    [
      '160244002', # No Known Allergies
      '414285001', # Food
    ]
  end
end
