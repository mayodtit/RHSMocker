class Api::V1::AllergiesController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  NO_KNOWN_ALLERGIES_SNOMED_CODE = '160244002'

  def index
    @allergies = if params[:q].blank?
      Allergy.where('snomed_code NOT in (?)', excluded_allergies).order('name ASC')
    else
      solr_results.reject{|a| excluded_allergies.include?(a.snomed_code) }
    end

    render_success({allergies: @allergies})
  end

  private

  def solr_results
    Allergy.search { fulltext params[:q] }.results
  end

  # array of snomed codes that we don't want to appear in results
  def excluded_allergies
    [
      '160244002', # No Known Allergies
      '414285001', # Food
    ]
  end
end
