class Api::V1::DietsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def list
    render_success(diets:Diet.all)
  end
end
