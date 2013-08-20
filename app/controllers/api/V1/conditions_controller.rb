class Api::V1::ConditionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    conditions = if params[:q].blank?
      Condition.all :order => 'name ASC'
    else
      Condition.search do
        fulltext params[:q]
      end
    end

    render_success({conditions:conditions})
  end
end
