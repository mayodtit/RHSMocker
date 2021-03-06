class LogAnalyticsJob
  def initialize(user_uuid, event_name, misc_params = {})
    @device_os_version = misc_params[:device_os_version]
    build_number = misc_params[:build_number]
    event_label = misc_params[:event_label]
    event_category = misc_params[:event_category] || DEFAULT_EVENT_CATEGORY

    # for debugging
    #t = Time.now.to_i
    #user_uuid = "testing_#{user_uuid}_#{t}"
    #build_number = "testing_#{build_number}_#{t}"

    @payload = {

      # details on parameters here: https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
      v:   '1',            # required - this shouldn't change
      tid: GA_TRACKING_ID, # required - tracking ID
      cid: user_uuid,      # required - user ID
      t:   'event',        # required - hit type
      an:  'better',       # required (for mobile app tracking) - app name
      ul:  'en-us',        # optional - user language
      aip: 1,              # optional - anomymize IP (to reduce pollution of location data)

      # event tracking is optional, but the following two are both required to track an event
      ea: event_name,      # event action
      ec: event_category,  # event category
    }

    @payload.merge!({av: build_number}) if build_number # optional - add app version if provided
    @payload.merge!({el: event_label})  if event_label  # optional - add event label if provided
  end

  def log_ga
    Curl::Easy.http_post('https://ssl.google-analytics.com/collect', @payload.to_query) do |c|
      c.headers['User-Agent'] = get_user_agent(@device_os_version) if @device_os_version
    end
  end
  handle_asynchronously :log_ga

  private

  # using request.user_agent results in "better-devloc/5047 CFNetwork/609.1.4 Darwin/12.4.0",
  # which Google Analytics doesn't map to an operating system
  def get_user_agent(device_os_version)
    case device_os_version
      when /^6\.0/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25'
      when /^6\.1/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B143 Safari/8536.25'

      # from http://user-agent-string.info/list-of-ua/os-detail?os=iOS%207
      when /^7\.0/ then 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/546.10 (KHTML, like Gecko) Version/6.0 Mobile/7E18WD Safari/8536.25'
      else nil
    end
  end
end
