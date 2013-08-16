class Api::V1::RemoteEventsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    remote_event = RemoteEvent.create(data: params.to_json)
    if remote_event.errors.empty?
      render_success
    else
      render_failure({reason: remote_event.errors.full_messages.to_sentence}, 422)
    end
  end
end
