class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type
  has_many :task_templates

  attr_accessible :name, :title, :description, :service_type_id, :service_type, :time_estimate, :timed_service, :user_facing

  validates :name, :title, :service_type, presence: true
  validates :user_facing, :inclusion => { :in => [true, false] }

  def time_estimate_from_now
    Time.now.business_minutes_from(time_estimate.to_i)
  end
end
