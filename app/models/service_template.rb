class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type
  has_many :task_templates
  has_many :suggested_service_templates

  attr_accessible :name, :title, :description, :service_type_id,
                  :service_type, :time_estimate, :timed_service,
                  :user_facing, :service_update, :service_request

  validates :name, :title, :service_type, presence: true
  validates :user_facing, inclusion: {in: [true, false]}

  def calculated_due_at(time=Time.now)
    time.business_minutes_from(time_estimate.to_i)
  end
end
