class RemoteEvent < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :data, :device_id
  validates :data, presence: true

  # TODO - disabled to reduce database load
  #after_create :log

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

  def uid
    (user && user.id) || device_id
  end

  private

  def log
    Analytics.log_remote_event(id)
    Analytics.log_mixpanel(id)
  end
end
