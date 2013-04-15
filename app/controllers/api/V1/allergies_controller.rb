class Api::V1::AllergiesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    allergies = if params[:q].blank?
      Allergy.all :order => 'name ASC'
    else
      Allergy.search do
        fulltext params[:q]
      end
    end

    render_success({allergies:allergies})
  end
end
