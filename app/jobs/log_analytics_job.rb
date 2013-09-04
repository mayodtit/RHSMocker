class LogAnalyticsJob
  def initialize(user_id, event_name)
    @user_id = user_id
    @event_name = event_name
  end

  def log_all
    log_mixpanel
    log_ga
  end

  def log_ga
    # TBD
  end
  handle_asynchronously :log_ga

  def log_mixpanel
    MIXPANEL.track(@user_id, @event_name)
  end
  handle_asynchronously :log_mixpanel
end