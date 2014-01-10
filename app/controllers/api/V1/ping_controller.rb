class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }

  def index
    hash = { revision: REVISION, use_invite_flow: Metadata.use_invite_flow? }
    if current_user
      metadata_hash = Metadata.to_hash_for(current_user)
      metadata_hash.delete('use_invite_flow')
      hash.merge!({metadata: metadata_hash})
    end
    render_success(hash)
  end
end
