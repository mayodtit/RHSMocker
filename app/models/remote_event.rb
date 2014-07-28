class RemoteEvent < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :data
  validates :data, presence: true

  after_create :log

  def build_number
    data_json['properties'].try(:[], 'app_build')
  end

  def events
    data_json['events']
  end

  def device_os_version
    data_json['properties'].try(:[], 'device_os_version')
  end

  def data_json
    @dj ||= JSON.parse(data)
  end

  private

  def log
    Analytics.log_remote_event(id)
    Analytics.log_mixpanel(id)
  end
end
