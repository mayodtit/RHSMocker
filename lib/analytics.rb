class Analytics
  class << self
    def log_remote_event(remote_event_id)
      remote_event = RemoteEvent.find(remote_event_id)
      user = remote_event.user || User.find_by_auth_token(remote_event.data_json['auth_token'])
      remote_event.events.each do |e|
        l = LogAnalyticsJob.new(user.google_analytics_uuid,
                                e['name'],
                                { build_number: remote_event.build_number,
                                  device_os_version: remote_event.device_os_version })
        l.log_ga
      end
    end
    handle_asynchronously :log_remote_event

    def log_started_symptoms_checker(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'started_symptom_checker').log_ga
    end
    handle_asynchronously :log_started_symptoms_checker

    def log_user_login(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'user_logged_in').log_ga
    end
    handle_asynchronously :log_user_login

    def log_user_logout(user_ga_uuid)
      LogAnalyticsJob.new(user_ga_uuid, 'user_logged_out').log_ga
    end
    handle_asynchronously :log_user_logout

    def log_content_search(user_ga_uuid, search_term)
      event_data = {event_label: search_term, event_category: SEARCH_CATEGORY}
      LogAnalyticsJob.new(user_ga_uuid, 'content_search', event_data).log_ga
    end
    handle_asynchronously :log_content_search
  end
end
