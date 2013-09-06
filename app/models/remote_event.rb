class RemoteEvent < ActiveRecord::Base
  attr_accessible :data
  validates :data, presence: true

  def log
    LogAnalyticsJob.new(self).log_all
  end
end
