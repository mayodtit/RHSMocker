class Analytics
  class << self
    def log_remote_event(remote_event_id)
      remote_event = RemoteEvent.find(remote_event_id)
      user = remote_event.user || User.find_by_auth_token(remote_event.data_json['auth_token'])
      remote_event.events.each do |e|
        l = LogAnalyticsJob.new(user.google_analytics_uuid,
                                e['name'],
                                remote_event.build_number,
                                remote_event.device_os_version)
        l.log_ga
      end
    end
    handle_asynchronously :log_remote_event
  end
end