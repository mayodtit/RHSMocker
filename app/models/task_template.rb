class TaskTemplate < ActiveRecord::Base
  belongs_to :service_template
  belongs_to :modal_template
  belongs_to :task_category
  has_many :tasks
  has_many :task_guides

  attr_accessible :name, :title, :description, :time_estimate, :priority, :service_ordinal, :service_template, :service_template_id, :modal_template, :queue, :task_category, :task_category_id

  before_validation :copy_title_to_name
  validates :name, :title, presence: true
  validate :no_placeholders_in_user_facing_attributes

  def create_task!(attributes = {})
    creator = attributes[:service] ? attributes[:service].creator : attributes[:creator]
    member = attributes[:service] ? attributes[:service].member : attributes[:member]

    if queue == 'pha'
      owner = member.try(:pha) || attributes[:owner] || (attributes[:service] && attributes[:service].owner)
    elsif queue == 'specialist' || queue == 'hcc'
      owner = nil
    else
      owner = attributes[:owner] || (attributes[:service] && attributes[:service].owner)
    end

    MemberTask.create!(
      title: attributes[:title] || title,
      description: attributes[:description] || description,
      due_at: (attributes[:start_at] || Time.now).business_minutes_from(time_estimate.to_i),
      time_estimate: time_estimate,
      task_template: self,
      task_category: task_category,
      service: attributes[:service],
      service_type: attributes[:service] ? attributes[:service].service_type : attributes[:service_type],
      service_ordinal: service_ordinal,
      member:  member,
      subject: attributes[:service] ? attributes[:service].subject : attributes[:subject],
      creator: creator,
      owner: owner,
      assignor: owner.present? ? (attributes[:assignor] || creator) : nil,
      queue: queue || :pha,
      time_zone: attributes[:service] ? attributes[:service].time_zone : attributes[:subject].try(:time_zone)
    )
  end

  def copy_title_to_name
    if !self.name
      self.name = self.title
    end
  end

  def create_deep_copy!(override_service_template=nil)
    new_modal_template = modal_template.try(:create_copy!)
    self.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'modal_template_id').merge(service_template: override_service_template || service_template, modal_template: new_modal_template || modal_template))
  end

  def no_placeholders_in_user_facing_attributes
    %i(name title description).each do |attribute|
      if send(attribute).try(:match, RegularExpressions.brackets)
        errors.add(attribute, "shouldn't contain any brackets other than markdown")
      end
    end
  end
end
