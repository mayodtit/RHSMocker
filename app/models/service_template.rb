class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type

  attr_accessible :name, :title, :description, :service_type_id, :service_type, :time_estimate

  validates :name, :title, :service_type, presence: true

  def create_service(attributes = {})
    Service.create(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      service_type: service_type,
      due_at: Time.now + time_estimate.to_i.hours,
      service_template: self,
      member: attributes[:member],
      subject: attributes[:subject],
      creator: attributes[:creator],
      owner: attributes[:owner],
      assignor: attributes[:assignor] || attributes[:creator],
      actor_id: attributes[:creator] && attributes[:creator].id
    )
  end
end
