class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }

  def index
    hash = { revision: REVISION }
    hash.merge!({metadata: Metadata.to_hash_for(current_user)}) if current_user
    render_success(hash)
  end
end
