class TaskTemplate < ActiveRecord::Base
  belongs_to :service_template
  belongs_to :modal_template
  has_many :tasks
  has_many :task_guides

  attr_accessible :name, :title, :description, :time_estimate, :priority, :service_ordinal, :service_template, :service_template_id, :modal_template

  validates :name, :title, presence: true

  def create_task!(attributes = {})
    creator = attributes[:service] ? attributes[:service].creator : attributes[:creator]
    owner = attributes[:owner] || (attributes[:service] && attributes[:service].owner)

    MemberTask.create!(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      due_at: (attributes[:start_at] || Time.now).business_minutes_from(time_estimate.to_i),
      time_estimate: time_estimate,
      task_template: self,
      service: attributes[:service],
      service_type: attributes[:service] ? attributes[:service].service_type : attributes[:service_type],
      service_ordinal: service_ordinal,
      member: attributes[:service] ? attributes[:service].member : attributes[:member],
      subject: attributes[:service] ? attributes[:service].subject : attributes[:subject],
      creator: creator,
      owner: owner,
      assignor: owner.present? ? (attributes[:assignor] || creator) : nil,
      priority: priority || 0
    )
  end

  def create_deep_copy!(override_service_template=nil)
    new_modal_template = modal_template.try(:create_copy!)
    self.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'modal_template_id').merge(service_template: override_service_template || service_template, modal_template: new_modal_template || modal_template))
  end
end
