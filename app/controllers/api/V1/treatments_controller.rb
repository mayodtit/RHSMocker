class Api::V1::TreatmentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    treatments = if params[:q].blank?
      (params[:type] ? Treatment.type_class(params[:type]) : Treatment).all :order => 'name ASC'
    else
      Treatment.search do
        fulltext params[:q]
        with :type, params[:type] if params[:type]
      end
    end

    render_success({treatments:treatments})
  end
end
