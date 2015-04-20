class Metrics
  include Singleton

  MESSAGE_RESPONSE_EVENT = 'Message Response'
  OPTION_KEYS = %i(@mixpanel_token @mixpanel_api_key @start_at @end_at @dry_run @debug)

  def configure(options={})
    @mixpanel_token = options[:mixpanel_token]
    @mixpanel_api_key = options[:mixpanel_api_key]
    @start_at = options[:start_at]
    @end_at = options[:end_at]
    @dry_run = options[:dry_run]
    @debug = options[:debug]
  end

  # For each incoming message (where the message user is the consult initiator)
  # identify the response and calculate the time between the message and the
  # response.
  #
  # Track most recently seen message per consult to prevent duplicate events.
  # Track messages that do not have responses separately so they do not affect
  # response time metrics until they receive a response.
  #
  def backfill_message_response_events
    imported_event_count = 0

    log("Processing #{messages.count} messages:\n")
    messages.find_each do |message|
      log('*') and next unless message.user_id == message.consult.initiator_id
      log('*') and next if last_seen_message_ids[message.consult_id] > message.id
      if response = identify_response(message)
        log('.')
        imported_event_count += 1
        track_event(message, response)
      else
        log('!')
        messages_without_response << message
      end
      last_seen_message_ids[message.consult_id] = (response || message).id
    end
    log("\nFinished processing messages\n\n")

    {
      needs_response: messages_without_response,
      imported_event_count: imported_event_count
    }
  end

  def reload
    instance_variables.each do |var|
      next if OPTION_KEYS.include?(var)
      remove_instance_variable(var)
    end
    self
  end
  alias_method :reload!, :reload

  private

  def log(message)
    print message if debug
    true
  end

  def messages
    Message.where('created_at > ?', start_at)
           .where('created_at <= ?', end_at)
           .includes(:consult)
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
      import_time: import_time.to_i,
      import_start_at: start_at.to_i,
      import_end_at: end_at.to_i
    }

    unless dry_run
      tracker.import(mixpanel_api_key,
                     message.user_id,
                     MESSAGE_RESPONSE_EVENT,
                     properties)
    end
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

  def start_at
    @start_at ||= Time.now.pacific.beginning_of_day - 1.week
  end

  def end_at
    @end_at ||= Time.now
  end

  def dry_run
    @dry_run
  end

  def debug
    @debug
  end

  def import_time
    @import_time ||= Time.now
  end
end
