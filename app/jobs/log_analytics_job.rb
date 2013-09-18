class LogAnalyticsJob
  def log_all(remote_event_id)
    remote_event = RemoteEvent.find(remote_event_id)
    data_json = JSON.parse(remote_event.data)
    events = data_json['events']
    @build_number = data_json['properties']['app_build']
    @user_agent = get_user_agent(data_json)
    user = remote_event.user || User.find_by_auth_token(data_json['auth_token'])
    @google_analytics_uuid = user.try(:google_analytics_uuid)

    events.each do |e|
      log_ga(e['name'])
    end
  end
  handle_asynchronously :log_all

  def log_ga(event_name)
    # docs on params here: https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
    payload = {

      # the following four are required
      v:   '1',                    # this shouldn't change
      tid: GA_TRACKING_ID,         # tracking ID
      cid: @google_analytics_uuid, # user ID
      t:   'event',                # hit type

      # for mobile app tracking, the app name is also required
      an: 'better',

      # optional params
      av: @build_number, # app version
      ul: 'en-us',       # user language

      # event tracking is optional, but the following two are both required to track an event
      ea: event_name,                      # event action
      ec: 'Better Default Event Category', # event category

      # anonymize IP to reduce pollution of location data
      aip: 1,
    }.to_query

    Curl::Easy.http_post('https://ssl.google-analytics.com/collect', payload) do |c|
      c.headers['User-Agent'] = @user_agent if @user_agent
    end
  end
  handle_asynchronously :log_ga

  # for debugging
  #def dev
  #  t = Time.now.to_i
  #  @user_id = "#{@user_id}_#{t}"
  #  @build_number = "#{@build_number}_#{t}"
  #  log_all
  #end

  private

  # using request.user_agent results in "better-devloc/5047 CFNetwork/609.1.4 Darwin/12.4.0",
  # which Google Analytics doesn't map to an operating system
  def get_user_agent(data_json)
    case data_json['properties']['device_os_version']
      when /^6\.0/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25'
      when /^6\.1/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B143 Safari/8536.25'
      else nil
    end
  end
end
