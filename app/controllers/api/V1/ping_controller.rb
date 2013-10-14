class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }

  def index
    if current_user
      render_success(:metadata => Metadata.to_hash)
    else
      render_success
    end
  end
end
