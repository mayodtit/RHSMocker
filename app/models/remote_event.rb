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
      LogAnalyticsJob.new(user_id_for_logging, e['name']).log_all
    end
  end
end
