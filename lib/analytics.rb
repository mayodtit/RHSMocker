# keep the parameters as lean as possible to not cause memory issues - don't pass in complex objects

class Analytics
  class << self
    def log_remote_event(remote_event_id)
      remote_event = RemoteEvent.find(remote_event_id)
      user = remote_event.user || Session.find_by_auth_token(remote_event.data_json['auth_token']).try(:member)

      # GA logging requires user
      return if user.nil?

      remote_event.events.each do |e|
        hash = {build_number: remote_event.build_number,
                device_os_version: remote_event.device_os_version,
                event_category: e['category']}

        # one off rule for logging card taps
        if e['name'] == 'card_tapped'
          hash.merge!({event_label: e['card_id']})
        end

        LogAnalyticsJob.new(user.google_analytics_uuid, e['name'], hash).log_ga
      end
    end
    handle_asynchronously :log_remote_event

    def log_mixpanel(remote_event_id)
      remote_event = RemoteEvent.find(remote_event_id)
      tracker = Mixpanel::Tracker.new MIXPANEL_TOKEN

      # If this is the first event with a device id and a user, merge their events in Mixpanel
      if remote_event.user && remote_event.device_id && RemoteEvent.where(user_id: remote_event.user.id, device_id: remote_event.device_id).count == 1
        tracker.alias remote_event.user.id, remote_event.device_id
      end

      remote_event.events.each do |e|
        hash = { time: e['created_at'] }
        tracker.import MIXPANEL_API_KEY, remote_event.uid, e['name'], hash
      end
    end
    handle_asynchronously :log_mixpanel

    def log_started_symptoms_checker(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'started_symptom_checker', get_latest_build_and_os(user_ga_uuid)).log_ga
    end
    handle_asynchronously :log_started_symptoms_checker

    def log_user_login(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'user_logged_in', get_latest_build_and_os(user_ga_uuid)).log_ga
    end
    handle_asynchronously :log_user_login

    def log_user_logout(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'user_logged_out', get_latest_build_and_os(user_ga_uuid)).log_ga
    end
    handle_asynchronously :log_user_logout

    def log_content_search(user_ga_uuid, search_term)
      event_data = {event_label: search_term, event_category: SEARCH_CATEGORY}
      event_data.merge!(get_latest_build_and_os(user_ga_uuid))
      LogAnalyticsJob.new(user_ga_uuid, 'content_search', event_data).log_ga
    end
    handle_asynchronously :log_content_search

    private

    # since most of the above logging methods don't include the app build version and OS,
    # let's attempt to fetch them based on the user's most recent RemoteEvent
    def get_latest_build_and_os(user_ga_uuid)
      user_id = User.find_by_google_analytics_uuid(user_ga_uuid).try(:id)
      return_hash = {}
      unless user_id.nil?
        re = RemoteEvent.where(user_id: user_id).last
        return_hash = { build_number: re.build_number, device_os_version: re.device_os_version } unless re.nil?
      end
      return_hash
    end
  end
end
