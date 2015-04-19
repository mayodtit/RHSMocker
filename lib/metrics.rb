class Metrics
  include Singleton

  MESSAGE_RESPONSE_EVENT = 'Message Response'

  def configure(token, api_key)
    @mixpanel_token = token
    @mixpanel_api_key = api_key
  end

  # For each incoming message (where the message user is the consult initiator)
  # identify the response and calculate the time between the message and the
  # response.
  #
  # Track most recently seen message per consult to prevent duplicate events.
  # Track messages that do not have responses separately so they do not affect
  # response time metrics until they receive a response.
  #
  def backfill_message_response_events(start_at)
    messages(start_at).find_each do |message|
      next unless message.user_id == message.consult.initiator_id
      next if last_seen_message_ids[message.consult_id] > message.id
      if response = identify_response(message)
        track_event(message, response)
      else
        messages_without_response << message
      end
      last_seen_message_ids[message.consult_id] = (response || message).id
    end
    messages_without_response
  end

  def reload
    instance_variables.each do |var|
      next if %i(@mixpanel_token @mixpanel_api_key).include?(var)
      remove_instance_variable(var)
    end
    self
  end
  alias_method :reload!, :reload

  private

  def messages(start_at)
    Message.where('created_at > ?', start_at).includes(:consult)
  end

  def identify_response(message)
    message.consult.messages
                   .where('id > ?', message.id)
                   .where('user_id != ?', message.user_id)
                   .first
  end

  def track_event(message, response)
    properties = {
      time: message.created_at.to_i,
      user_id: message.user_id,
      responder_id: response.user_id,
      message_id: message.id,
      response_id: response.id,
      duration: response.created_at.to_i - message.created_at.to_i,
      import_time: import_time.to_i
    }

    tracker.import(mixpanel_api_key,
                   message.user_id,
                   MESSAGE_RESPONSE_EVENT,
                   properties)
  end

  # track, per consult id, the latest seen message; this prevents duplicate
  # events when a user sends us multiple messages in a row
  def last_seen_message_ids
    @last_seen_message_ids ||= Hash.new(0)
  end

  def messages_without_response
    @messages_without_response ||= []
  end

  def tracker
    @tracker ||= Mixpanel::Tracker.new(mixpanel_token)
  end

  def mixpanel_token
    @mixpanel_token ||= ENV['MIXPANEL_TOKEN']
  end

  def mixpanel_api_key
    @mixpanel_api_key ||= ENV['MIXPANEL_API_KEY']
  end

  def import_time
    @import_time ||= Time.now
  end
end
