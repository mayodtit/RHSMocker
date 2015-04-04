class Service < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  OPEN_STATES = %w(completed abandoned)

  belongs_to :service_type
  belongs_to :service_template
  belongs_to :member
  belongs_to :subject, class_name: 'User'
  belongs_to :owner, class_name: 'Member'
  belongs_to :creator, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :abandoner, class_name: 'Member'
  has_many :tasks
  has_many :service_changes

  attr_accessor :actor_id, :change_tracked, :reason
  attr_accessible :description, :title, :service_type_id, :service_type, :user_facing, :service_request, :service_deliverable,
                  :member_id, :member, :subject_id, :subject, :reason, :abandoner, :abandoner_id,
                  :creator_id, :creator, :owner_id, :owner, :assignor_id, :assignor,
                  :actor_id, :due_at, :state_event, :service_template, :service_template_id

  validates :title, :service_type, :state, :member, :creator, :owner, :assignor, :assigned_at, presence: true
  validates :user_facing, inclusion: {in: [true, false]}
  validates :service_template, presence: true, if: ->(s){s.service_template_id}

  before_validation :set_defaults, on: :create
  before_validation :set_assigned_at
  after_create :create_next_ordinal_tasks
  after_commit :track_update, on: :update
  after_commit :publish

  def open?
    !(OPEN_STATES.include? state)
  end

  def create_next_ordinal_tasks(current_ordinal=-1, last_due_at=Time.now)
    return unless open? && service_template && tasks.open_state.empty?

    if next_ordinal = next_ordinal(current_ordinal)
      service_template.task_templates.where(service_ordinal: next_ordinal).each do |task_template|
        task_template.create_task!(service: self, start_at: service_template.timed_service? ? last_due_at : Time.now, assignor: assignor)
      end
    else
      complete!
    end
  end

  private

  state_machine initial: :open do
    store_audit_trail to: 'ServiceChange', context_to_log: %i(actor_id data reason)

    event :wait do
      transition :open => :waiting
    end

    event :reopen do
      transition any - :open => :open
    end

    event :complete do
      transition any - %i(completed abandoned) => :completed
    end

    event :abandon do
      transition any - %i(completed abandoned) => :abandoned
    end

    before_transition any - :completed => :completed do |service|
      service.completed_at = Time.now
    end

    before_transition any - :abandoned => :abandoned do |service|
      service.abandoned_at = Time.now
    end

    after_transition any - :completed => :completed do |service|
      Task.where(service_id: service.id).each do |task|
        task.complete!
      end
    end

    after_transition any - :abandoned => :abandoned do |service|
      Task.where(service_id: service.id).each do |task|
        task.abandoner = service.abandoner
        task.reason = service.reason
        task.abandon!
      end
    end

    after_transition any => any do |service|
      service.change_tracked = true
    end
  end

  def next_ordinal(current_ordinal)
    return unless service_template
    service_template.task_templates.where('service_ordinal > ?', current_ordinal).minimum(:service_ordinal)
  end

  def actor_id
    @actor_id || owner_id || creator_id
  end

  IGNORED_ATTRIBUTES = %i(:state,
                          :created_at,
                          :updated_at,
                          :assigned_at,
                          :completed_at,
                          :abandoned_at,
                          :abandoner_id,
                          :creator_id,
                          :assignor_id)
  def data
    changes = previous_changes.except(IGNORED_ATTRIBUTES)
    changes.empty? ? nil : changes
  end

  def set_defaults
    if service_template
      self.title ||= service_template.title
      self.description ||= service_template.description
      self.due_at ||= service_template.time_estimate_from_now
      self.user_facing ||= service_template.user_facing
    end
    self.subject ||= member
    self.owner ||= member.pha
    self.assignor ||= creator
    self.actor ||= creator
    true
  end

  def set_assigned_at
    self.assigned_at = Time.now if owner_id_changed?
  end

  def publish
    PubSub.publish "/members/#{member_id}/subjects/#{subject_id}/services/#{new_or_update}", {id: id}
  end

  def new_or_update
    id_changed? ? 'new' : 'update'
  end

  def track_update
    # If audit_trail tells us it's already logged change, do nothing.
    if change_tracked
      self.change_tracked = false
    elsif _data = data
      ServiceChange.create! service: self, actor_id: self.actor_id, event: 'update', data: _data, reason: reason
    end
  end
end
