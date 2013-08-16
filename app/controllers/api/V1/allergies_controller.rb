class Api::V1::AllergiesController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  NO_KNOWN_ALLERGIES_SNOMED_CODE = '160244002'

  def index
    @allergies = if params[:q].blank?
      Allergy.where('snomed_code is NOT ?', NO_KNOWN_ALLERGIES_SNOMED_CODE).order('name ASC')
    else
      solr_results.reject{|a| a.snomed_code == NO_KNOWN_ALLERGIES_SNOMED_CODE}
    end

    render_success({allergies: @allergies})
  end

  private

  def solr_results
    Allergy.search { fulltext params[:q] }.results
  end
end
