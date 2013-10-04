class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    render_success
  end
end
