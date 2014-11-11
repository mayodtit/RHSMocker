class Api::V1::PingController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :unless => lambda{ params[:auth_token] }
  after_filter :store_apns_token!, if: -> { params[:auth_token] }
  after_filter :store_gcm_id!, if: -> { params[:auth_token] }
  after_filter :store_device_information!, if: -> { params[:auth_token] }
  after_filter :store_user_information!, if: -> { params[:auth_token] }

  def index
    hash = {
      revision: REVISION,
      use_invite_flow: Metadata.use_invite_flow?,
      enable_sharing: Metadata.enable_sharing?,
      nux: { question: Metadata.nux_question_text, answers: NuxAnswer.active.serializer },
      stories: stories,
      splash_story: splash_story,
      question_story: question_story
    }

    if current_user
      metadata_hash = Metadata.to_hash_for(current_user)
      metadata_hash.delete('use_invite_flow')
      metadata_hash.delete('version')
      metadata_hash.delete('app_store_url')
      metadata_hash.delete('nux_question_text')
      hash.merge!({metadata: metadata_hash})
    end

    if ios_version_valid? || android_version_valid?
      hash.merge!(valid: true)
    else
      hash.merge!(valid: false,
                  app_store_url: Metadata.value_for_key('app_store_url'),
                  google_play_url: Metadata.value_for_key('google_play_url'))
    end

    render_success(hash)
  end

  alias_method :create, :index

  private

  def store_apns_token!
    current_session.store_apns_token!(params[:device_token]) if params[:device_token]
  end

  def store_gcm_id!
    current_session.store_gcm_id!(params[:android_gcm_id]) if params[:android_gcm_id]
  end

  def store_device_information!
    changed_attributes = {}

    if params[:device_os] && (current_session.device_os != params[:device_os])
      changed_attributes[:device_os] = params[:device_os]
    end

    if params[:app_version] && (current_session.device_app_version != params[:app_version])
      changed_attributes[:device_app_version] = params[:app_version]
    end

    if params[:app_build] && (current_session.device_app_build != params[:app_build])
      changed_attributes[:device_app_build] = params[:app_build]
    end

    if params[:device_timezone] && (current_session.device_timezone != params[:device_timezone])
      changed_attributes[:device_timezone] = params[:device_timezone]
    end

    if !params[:notifications_enabled].nil? && (current_session.device_notifications_enabled != params[:notifications_enabled])
      changed_attributes[:device_notifications_enabled] = params[:notifications_enabled]
    end

    if params[:device_id] && (current_session.device_id != params[:device_id])
      changed_attributes[:device_id] = params[:device_id]
    end

    if params[:advertiser_id] && (current_session.advertiser_id != params[:advertiser_id])
      changed_attributes[:advertiser_id] = params[:advertiser_id]
    end

    unless changed_attributes.empty?
      current_session.update_attributes!(changed_attributes)
    end
  end

  def store_user_information!
    changed_attributes = {}

    if params[:device_timezone] && (current_user.time_zone != params[:device_timezone])
      changed_attributes[:time_zone] = params[:device_timezone]
    end

    if !params[:notifications_enabled].nil? && (current_user.cached_notifications_enabled != params[:notifications_enabled])
      changed_attributes[:cached_notifications_enabled] = params[:notifications_enabled]
    end

    unless changed_attributes.empty?
      current_user.update_attributes!(changed_attributes)
    end
  end

  def stories
    NuxStory.enabled.serializer.as_json
  end

  def splash_story
    NuxStory.splash.try(:serializer)
  end

  def question_story
    NuxStory.question.try(:serializer)
  end

  def ios_version
    Gem::Version.new(params[:app_version] || params[:version] || '0.0.0')
  end

  MINIMUM_IOS_VERSION = '1.0.0'
  def minimum_ios_version
    Gem::Version.new(Metadata.value_for_key('version') || '1.0.0')
  end

  def ios_version_valid?
    ios_version >= minimum_ios_version
  end

  def android_version
    Gem::Version.new(params[:android_app_version] || '0.0.0')
  end

  MINIMUM_ANDROID_VERSION = '0.0.1'
  def minimum_android_version
    Gem::Version.new(Metadata.value_for_key('android_version') || '0.0.1')
  end

  def android_version_valid?
    android_version >= minimum_android_version
  end
end
