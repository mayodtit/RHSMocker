class Api::V1::ConditionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    conditions = if params[:q].blank?
      Condition.order('name ASC')
    else
      Condition.search do
        fulltext params[:q]
      end
    end

    render_success(diseases: conditions) and return if diseases_path?
    index_resource(conditions)
  end

  private

  def diseases_path?
    request.env['PATH_INFO'].include?('disease')
  end
end
