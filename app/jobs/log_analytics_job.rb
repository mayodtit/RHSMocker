class LogAnalyticsJob
  def initialize(remote_event)
    @data_json = JSON.parse(remote_event.data)

    @events = @data_json['events']
    @build_number = @data_json['properties']['app_build']
    @user_agent = get_user_agent

    user = User.find_by_auth_token(@data_json['auth_token'])
    @mixpanel_uuid = user.mixpanel_uuid
    @google_analytics_uuid = user.google_analytics_uuid
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
      v:   '1',                         # this shouldn't change
      tid: GA_TRACKING_ID,              # tracking ID
      cid: @google_analytics_uuid,      # user ID
      t:   'event',                     # hit type

      # optional params
      an: 'better',                     # app name
      av: @build_number,                # app version
      ea: event_name,                   # event action
      ul: 'en-us',                      # user language
    }.to_query

    Curl::Easy.http_post('https://ssl.google-analytics.com/collect', payload) do |c|
      c.headers['User-Agent'] = @user_agent if @user_agent
    end
  end
  handle_asynchronously :log_ga

  def log_mixpanel(event_name)
    hash = @data_json['properties']
    hash.delete('device_id') # Google Analytics doesn't allow device ID logging; don't log to Mixpanel, either

    MIXPANEL.track(@mixpanel_uuid, event_name, hash)
  end
  handle_asynchronously :log_mixpanel

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
  def get_user_agent
    case @data_json['properties']['device_os_version']
      when /^6\.0/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25'
      when /^6\.1/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B143 Safari/8536.25'
      else nil
    end
  end
end