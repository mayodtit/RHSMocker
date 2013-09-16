class RemoteEvent < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :data
  validates :data, presence: true

  after_create :log

  private

  def log
    LogAnalyticsJob.new.log_all(id)
  end
end
