class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type
  has_many :task_templates

  attr_accessible :name, :title, :description, :service_type_id, :service_type, :time_estimate, :timed_service, :user_facing

  validates :name, :title, :service_type, presence: true
  validates :user_facing, :inclusion => { :in => [true, false] }

  def create_service!(attributes = {})
    service = Service.create!(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      service_type: service_type,
      due_at: attributes[:due_at] || Time.now.business_minutes_from(time_estimate.to_i),
      service_template: self,
      member: attributes[:member],
      subject: attributes[:subject] || attributes[:member],
      creator: attributes[:creator],
      owner_id: attributes[:owner_id] || attributes[:member] && attributes[:member].pha.id,
      assignor: attributes[:assignor] || attributes[:creator],
      actor_id: attributes[:creator] && attributes[:creator].id,
      user_facing: attributes[:user_facing] || user_facing,
      service_request: attributes[:service_request],
      pubsub_client_id: attributes[:pubsub_client_id]
    )
    service.create_next_ordinal_tasks
    service
  end
end
