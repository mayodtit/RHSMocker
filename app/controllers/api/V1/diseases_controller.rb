class Api::V1::DiseasesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    diseases = if params[:q].blank?
      Disease.all :order => 'name ASC'
    else
      Disease.search do
        fulltext params[:q]
      end
    end

    render_success({diseases:diseases})
  end
end
