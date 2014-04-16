class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }
  after_filter :store_apns_token!, if: -> { params[:auth_token] }

  def index
    hash = { revision: REVISION, use_invite_flow: Metadata.use_invite_flow? }
    if current_user
      metadata_hash = Metadata.to_hash_for(current_user)
      metadata_hash.delete('use_invite_flow')
      metadata_hash.delete('version')
      metadata_hash.delete('app_store_url')
      hash.merge!({metadata: metadata_hash})
    end

    if Gem::Version.new(params[:app_version] || params[:version] || '1.0.0') >= Gem::Version.new(Metadata.value_for_key('version') || '1.0.0')
      hash.merge!(valid: true)
    else
      hash.merge!(valid: false, app_store_url: Metadata.value_for_key('app_store_url'))
    end

    render_success(hash)
  end

  alias_method :create, :index

  private

  def store_apns_token!
    current_user.store_apns_token!(params[:device_token]) if params[:device_token]
  end
end
