class TaskTemplate < ActiveRecord::Base
  belongs_to :service_template
  has_many :tasks
  has_many :task_guides

  attr_accessible :name, :title, :description, :time_estimate, :service_ordinal, :service_template

  validates :name, :title, presence: true

  def create_task!(attributes = {})
    creator = attributes[:service] ? attributes[:service].creator : attributes[:creator]
    owner = attributes[:owner] || (attributes[:service] && attributes[:service].owner)

    MemberTask.create!(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      due_at: (attributes[:start_at] || Time.now) + time_estimate.to_i.minutes,
      task_template: self,
      service: attributes[:service],
      service_type: attributes[:service] ? attributes[:service].service_type : attributes[:service_type],
      service_ordinal: service_ordinal,
      member: attributes[:service] ? attributes[:service].member : attributes[:member],
      subject: attributes[:service] ? attributes[:service].subject : attributes[:subject],
      creator: creator,
      owner: owner,
      assignor: owner.present? ? (attributes[:assignor] || creator) : nil
    )
  end
end
