class Api::V1::RemoteEventsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    has_errors = false
    json = params['Events'].inject([]) do |response, event|
      remote_event = RemoteEvent.create(format_params(event, params['Properties']))
      if remote_event.errors.empty?
        response << {status: :success}
      else
        has_errors = true
        response << {status: :failure, reason: remote_event.errors.full_messages.to_sentence}
      end
      response
    end

    if has_errors
      render json: json, status: :unprocessable_entity
    else
      render json: json
    end
  end

  private

  def format_params(event, properties)
    {
      name: event['name'],
      device_created_at: event['createdat'],
      device_language: properties['Device-Language'],
      device_os: properties['Device-OS'],
      device_os_version: properties['Device-OS-Version'],
      device_model: properties['Device-Model'],
      device_timezone_offset: properties['Device-Timezone-offset'],
      app_version: properties['App-Version'],
      app_build: properties['App-Build']
    }
  end
end
