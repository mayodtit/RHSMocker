class ServiceTemplate < ActiveRecord::Base
  belongs_to :service_type
  has_many :task_templates
  has_many :suggested_service_templates

  attr_accessible :name, :title, :description, :service_type_id, :service_type, :time_estimate, :timed_service,
                  :user_facing, :service_update, :service_request, :unique_id, :version, :state

  validates :name, :title, :service_type, presence: true
  validates :user_facing, :inclusion => { :in => [true, false] }
  validates :unique_id, uniqueness: true
  validates :version, presence: true, uniqueness: true, if: ->(st){st.unique_id}
  validates :state, presence: true, uniqueness: true, if: ->(st){st.unique_id && st.version}

  before_validation :set_unique_id, on: :create
  before_validation :set_version, on: :create

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
      service_update: attributes[:service_update] || service_update
    )
    service.create_next_ordinal_tasks
    service
  end

  def set_unique_id
    self.unique_id ||= loop do
      new_unique_id = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_unique_id unless self.class.exists?(unique_id: new_unique_id)
    end
  end

  def set_version
    self.version = self.class.where(unique_id: unique_id).maximum(:version).try(:+, 1) || 0
    self.save!
  end

  state_machine :initial => :unpublished do

    event :publish do
      transition :unpublished => :published
    end

    event :retire do
      transition :published => :retired
    end
  end
end
