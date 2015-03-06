class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type
  has_many :task_templates

  attr_accessible :name, :title, :description, :service_type_id, :service_type, :time_estimate

  validates :name, :title, :service_type, presence: true

  def create_service!(attributes = {})
    service = Service.create!(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      service_type: service_type,
      due_at: Time.now.business_minutes_from(time_estimate.to_i),
      service_template: self,
      member: attributes[:member],
      subject: attributes[:subject] || attributes[:member],
      creator: attributes[:creator],
      owner: attributes[:owner] || attributes[:member] && attributes[:member].pha,
      assignor: attributes[:assignor] || attributes[:creator],
      actor_id: attributes[:creator] && attributes[:creator].id
    )
    service.create_tasks(0)
    service
  end
end
