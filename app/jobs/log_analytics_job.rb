class LogAnalyticsJob
  def initialize(remote_event)
    data_json = JSON.parse(remote_event.data)

    @user_id = data_json['auth_token']
    @events = data_json['events']
    @build_number = data_json['properties']['app_build']
  end

  def log_all
    @events.each do |e|
      log_mixpanel(e['name'])
      log_ga(e['name'])
    end
  end

  def log_ga(event_name)
    # docs on params here: https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
    payload = {

      # the following four are required
      v:   '1',             # this shouldn't change
      tid: GA_TRACKING_ID,  # tracking ID
      cid: @user_id,        # user ID
      t:   'event',         # hit type

      # optional params
      an: 'better',         # app name
      av: @build_number,    # app version
      ea: event_name,       # event action
    }.to_query

    # user agent isn't required
    Curl.post('https://ssl.google-analytics.com/collect', payload)
  end
  handle_asynchronously :log_ga

  def log_mixpanel(event_name)
    MIXPANEL.track(@user_id, event_name)
  end
  handle_asynchronously :log_mixpanel
end