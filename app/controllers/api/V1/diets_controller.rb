class Api::V1::DietsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    index_resource(Diet.all)
  end
end
