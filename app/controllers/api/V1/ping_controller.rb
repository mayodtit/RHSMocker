class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }
  after_filter :store_apns_token!, if: -> { params[:auth_token] }
  after_filter :store_gcm_id!, if: -> { params[:auth_token] }
  after_filter :store_device_information!, if: -> { params[:auth_token] }

  def index
    hash = {
      revision: REVISION,
      use_invite_flow: Metadata.use_invite_flow?,
      enable_sharing: Metadata.enable_sharing?,
      nux: { question: Metadata.nux_question_text, answers: NuxAnswer.active.serializer }
    }

    if current_user
      metadata_hash = Metadata.to_hash_for(current_user)
      metadata_hash.delete('use_invite_flow')
      metadata_hash.delete('version')
      metadata_hash.delete('app_store_url')
      metadata_hash.delete('nux_question_text')
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

  def store_gcm_id!
    current_user.store_gcm_id!(params[:android_gcm_id]) if params[:android_gcm_id]
  end

  def store_device_information!
    changed_attributes = {}

    if params[:device_os] && (current_user.device_os != params[:device_os])
      changed_attributes[:device_os] = params[:device_os]
    end

    if params[:app_version] && (current_user.device_app_version != params[:app_version])
      changed_attributes[:device_app_version] = params[:app_version]
    end

    if params[:app_build] && (current_user.device_app_build != params[:app_build])
      changed_attributes[:device_app_build] = params[:app_build]
    end

    if params[:device_timezone] && (current_user.device_timezone != params[:device_timezone])
      changed_attributes[:device_timezone] = params[:device_timezone]
    end

    if !params[:notifications_enabled].nil? && (current_user.device_notifications_enabled != params[:notifications_enabled])
      changed_attributes[:device_notifications_enabled] = params[:notifications_enabled]
    end

    if params[:device_id] && (current_user.install_id != params[:device_id])
      changed_attributes[:install_id] = params[:device_id]
    end

    unless changed_attributes.empty?
      current_user.update_attributes!(changed_attributes)
    end
  end
end
