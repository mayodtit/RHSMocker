class Api::V1::DiseasesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    @deseases = if params[:q].blank?
      Disease.all :order => 'title ASC'
    else
      Disease.search do
        fulltext params[:q]
      end
    end

    render :json => @deseases
  end
end
