class RemoteEvent < ActiveRecord::Base
  attr_accessible :data
  validates :data, presence: true

  def data_json
    @data_json ||= JSON.parse(data)
  end

  def events
    data_json['events']
  end

  def user_id_for_logging
    data_json['auth_token']
  end

  def log
    events.each do |e|
      log_mixpanel(e['name'])
      log_ga
    end
  end

  def log_ga
    # TBD
  end

  def log_mixpanel(event_name)
    MIXPANEL.track(user_id_for_logging, event_name)
  end
end
