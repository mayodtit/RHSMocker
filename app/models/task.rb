class Task < ActiveRecord::Base
  QUEUE_TYPES = %i(hcc pha nurse specialist)
  symbolize :queue, in: QUEUE_TYPES

  belongs_to :member
  belongs_to :subject, class_name: 'User'
  belongs_to :role, class_name: 'Role'
  belongs_to :owner, class_name: 'Member'
  belongs_to :creator, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :abandoner, class_name: 'Member'
  belongs_to :service
  belongs_to :service_type
  belongs_to :task_template
  belongs_to :task_category
  has_many :task_changes, class_name: 'TaskChange', order: 'created_at DESC'
  has_many :task_steps, inverse_of: :task,
                        dependent: :destroy
  has_many :task_data_fields, inverse_of: :task,
                              dependent: :destroy
  has_many :data_fields, through: :task_data_fields,
                         include: :data_field_template
  has_many :input_task_data_fields, class_name: 'TaskDataField',
                                    conditions: {type: :input}
  has_many :input_data_fields, through: :input_task_data_fields,
                               source: :data_field,
                               include: :data_field_template
  has_many :output_task_data_fields, class_name: 'TaskDataField',
                                    conditions: {type: :output}
  has_many :output_data_fields, through: :output_task_data_fields,
                                source: :data_field,
                                include: :data_field_template
  has_many :service_data_fields, through: :service,
                                 source: :data_fields,
                                 include: :data_field_template
  has_one :entry, as: :resource

  attr_accessor :actor_id, :change_tracked, :reason, :pubsub_client_id, :start_at
  attr_accessible :title, :description, :due_at, :queue, :time_zone, :time_zone_offset,
                  :owner, :owner_id, :member, :member_id,
                  :subject, :subject_id, :creator, :creator_id, :assignor, :assignor_id,
                  :abandoner, :abandoner_id, :role, :role_id,
                  :state_event, :service_type_id, :service_type, :task_category, :task_category_id,
                  :task_template, :task_template_id, :service, :service_id, :service_ordinal,
                  :priority, :actor_id, :member_id, :member, :reason, :reason_blocked, :visible_in_queue,
                  :day_priority, :time_estimate, :pubsub_client_id, :urgent, :unread, :follow_up, :start_at

  validates :title, :state, :creator_id, :role_id, :due_at, :priority, presence: true
  validates :urgent, :unread, :follow_up, :inclusion => { :in => [true, false] }
  validates :owner, presence: true, if: lambda { |t| t.owner_id }
  validates :role, presence: true, if: lambda { |t| t.role_id }
  validates :service_type, presence: true, if: lambda { |t| t.service_type_id }
  validates :service, presence: true, if: lambda { |t| t.service_id }
  validates :service_ordinal, presence: true, if: lambda { |t| t.service_id }
  validates :task_template, presence: true, if: lambda { |t| t.task_template_id }
  validates :member, presence: true, if: lambda { |t| t.member_id }
  validates :reason, presence: true, if: lambda { |t| (t.due_at_changed? && t.due_at_was.present?) || (t.state_changed? && t.abandoned?) }
  validate :attrs_for_states

  before_validation :set_defaults, on: :create
  before_validation :reinitialize_state_machine, on: :create
  before_validation :set_assignor
  before_validation :mark_as_unread
  before_validation :update_priority_score, on: :update
  after_create :create_task_data_fields!, if: :task_template
  after_create :create_task_steps!, if: :task_template

  after_save :notify
  after_commit :publish
  after_commit :track_update, on: :update

  def self.open_state
    where(state: %i(unclaimed blocked_internal blocked_external claimed))
  end

  def self.blocked
    where(state: %i(blocked_internal blocked_external))
  end

  def self.nurse_queue
    where(queue: :nurse, state: :unclaimed)
  end

  def self.hcc_queue(hcp)
    where(queue: :hcc).where(['(state IN (?)) OR (state IN (?) AND owner_id = ?)', :unclaimed, :claimed, hcp.id])
  end

  def self.pha_queue(hcp)
    where(owner_id: hcp.id).open_state
  end

  def self.specialist_queue(hcp)
    where('queue = "specialist" AND owner_id = ? AND state = "claimed"', hcp.id)
  end

  def self.next_tasks
    task = Task.where(queue: :specialist).where(state: :unclaimed).includes(:member, :member => :phone_numbers).order(task_order).first
    if task
      [task]
    else
      []
    end
  end

  def self.claim_next_tasks!(hcp)
    transaction do
      next_tasks.each do |t|
        t.owner = hcp
        t.actor_id = hcp.id
        t.claim!
      end
    end
  end

  def blocked?
    %w(blocked_internal blocked_external).include? state
  end

  def open?
    !(%w(completed abandoned).include? state)
  end

  def self.claimed
    where(state: :claimed)
  end

  def for_nurse?
    role.name == 'nurse'
  end

  def for_pha?
    role.name == 'pha'
  end

  def self.open
    where('state NOT IN (?)', ['completed', 'abandoned'])
  end

  def update_priority_score
    self.priority = calculate_priority
  end


  def mark_as_unread
    if urgent? || (owner && owner.has_role?('specialist'))
      self.unread = false
    elsif (owner_id_changed? || id_changed?) && owner_id && assignor_id != owner_id && type == 'MemberTask'
      self.unread = true
    end
    true
  end

  def unassigned?
    owner_id.nil?
  end

  def publish
    if id_changed?
      PubSub.publish "/tasks/new", { id: id }, pubsub_client_id
    else
      PubSub.publish "/tasks/update", { id: id },  pubsub_client_id
      PubSub.publish "/tasks/#{id}/update", { id: id },  pubsub_client_id
    end

    if owner_id.present?
      PubSub.publish "/users/#{owner_id}/tasks/owned/update", { id: id },  pubsub_client_id
    end

    if owner_id_changed? && owner_id_was
      PubSub.publish "/users/#{owner_id_was}/tasks/owned/update", { id: id },  pubsub_client_id
    end

    if queue.present?
      PubSub.publish "/tasks/queue/#{queue}", { id: id }
    end
  end

  # call initialize twice to make sure dynamic initial state is set correctly
  def reinitialize_state_machine
    initialize_state_machines(dynamic: :force)
  end

  def initial_state
    if completed? || abandoned? || blocked_internal? || blocked_external?
      state.to_sym
    elsif owner.present?
      :claimed
    else
      :unclaimed
    end
  end

  state_machine initial: -> (t){t.initial_state} do
    store_audit_trail to: 'TaskChange', context_to_log: [:actor_id, :data, :reason]

    state :completed do
      validate :task_steps_completed
    end

    event :unclaim do
      transition any => :unclaimed
    end

    event :claim do
      transition any => :claimed
    end

    event :abandon do
      transition any => :abandoned
    end

    event :complete do
      transition any => :completed
    end

    event :report_blocked_by_internal do
      transition any => :blocked_internal
    end

    event :report_blocked_by_external do
      transition any => :blocked_external
    end

    event :unblock do
      transition %i(blocked_internal blocked_external) => :unclaimed
    end

    before_transition any - :unclaimed => :unclaimed do |task|
      task.owner_id = nil
      task.unclaimed_at = Time.now
    end

    before_transition any - :blocked_internal => :blocked_internal do |task|
      task.owner_id = task.member && task.member.pha_id
      task.queue = :pha
      task.service.wait! if task.service
      task.blocked_internal_at = Time.now
    end

    before_transition any - :blocked_external => :blocked_external do |task|
      task.owner_id = task.member && task.member.pha_id
      task.queue = :pha
      task.service.wait! if task.service
      task.blocked_external_at = Time.now
    end

    before_transition %i(blocked_internal blocked_external) => any - %i(blocked_internal blocked_external) do |task|
      task.unblocked_at = Time.now
    end

    before_transition any - :claimed => :claimed do |task|
      task.claimed_at = Time.now
    end

    before_transition any - :completed => :completed do |task|
      task.completed_at = Time.now
    end

    after_transition any - :completed => :completed  do |task|
      task.service.create_next_ordinal_tasks(task.service_ordinal, task.due_at) if task.service
    end

    before_transition any - :abandoned => :abandoned do |task|
      task.abandoned_at = Time.now
    end

    # Audit trail will create a TaskChange in an after_transition. This tells
    # after_commit track_update to not create another TaskChange
    after_transition any => any do |task|
      task.change_tracked = true
    end
  end

  # TODO: Write more comprehensive tests
  def attrs_for_states
    if owner_id.present?
      errors.add(:assignor_id, "must be present when #{self.class.name} is assigned") if assignor_id.nil?
      errors.add(:assigned_at, "must be present when #{self.class.name} is assigned") if assigned_at.nil?
    end

    case state
      when 'claimed'
        validate_actor_and_timestamp_exist :claim
      when 'blocked_internal'
        validate_actor_and_timestamp_exist :report_blocked_by_internal
      when 'blocked_external'
        validate_actor_and_timestamp_exist :report_blocked_by_external
      when 'completed'
        validate_actor_and_timestamp_exist :complete
      when 'abandoned'
        validate_actor_and_timestamp_exist :abandon
    end

    if unclaimed? && owner_id
      errors.add(:owner_id, "must be nil when #{self.class.name} is #{state}")
    end

    if %w(claimed completed).include? state
      if owner_id.nil?
        errors.add(:owner_id, "must be present when #{self.class.name} is #{state}")
      end
    end
  end

  def task_steps_completed
    unless task_steps.incomplete.empty?
      errors.add(:task_steps, 'must be completed before completing task')
    end
  end

  def actor_id
    @actor_id || Member.robot.id
  end

  def data
    changes = previous_changes.except(
      :state,
      :visible_in_queue,
      :created_at,
      :updated_at,
      :assigned_at,
      :claimed_at,
      :unclaimed_at,
      :unblocked_at,
      :blocked_internal_at,
      :blocked_external_at,
      :completed_at,
      :abandoned_at,
      :abandoner_id,
      :creator_id,
      :assignor_id)
    changes.empty? ? nil : changes
  end

  def track_update
    # If audit_trail tells us it's already logged change, do nothing.
    if change_tracked
      self.change_tracked = false
    elsif _data = data
      TaskChange.create! task: self, actor_id: self.actor_id, event: 'update', data: _data, reason: reason
    end
  end

  def notify
    return unless for_pha?

    if owner_id_changed? || id_changed?
      if unassigned?
        Role.pha.users.where(on_call: true).each do |m|
          UserMailer.delay.notify_of_unassigned_task self, m
        end
      elsif assignor_id != owner_id
        UserMailer.delay.notify_of_assigned_task self, owner
      end
    end
  end

  protected

  def default_queue
    :pha
  end

  def calculate_priority
    if queue == :hcc || type != 'MemberTask'
      priority ? priority : 0
    else
      CalculatePriorityService.new(task: self, service: self.service).call
    end
  end

  def calculate_owner
    if queue == :specialist || queue == :hcc
      nil
    else
      service.try(:owner) || member.try(:pha)
    end
  end

  def set_defaults
    self.queue ||= task_template.try(:queue) || default_queue
    self.title ||= task_template.try(:title)
    self.description ||= task_template.try(:description)
    self.due_at ||= task_template.try(:calculated_due_at, start_at)
    self.time_estimate ||= task_template.try(:time_estimate)
    self.service_type ||= service.try(:service_type)
    self.task_category ||= task_template.try(:task_category)
    self.member ||= service.try(:member)
    self.subject ||= service.try(:subject)
    self.creator ||= service.try(:creator)
    self.owner ||= calculate_owner
    self.assignor ||= owner
    self.role ||= Role.find_by_name(:pha)
    self.priority = calculate_priority
    self.service_ordinal ||= task_template.try(:service_ordinal) || service_ordinal_for_one_off
    self.time_zone ||= service.try(:time_zone) || member.try(:time_zone)
    self.time_zone_offset = ActiveSupport::TimeZone.new(time_zone).try(:utc_offset) if time_zone
    true
  end

  private

  def self.task_order
    pacific_offset = Time.zone_offset('PDT')/3600
    "DATE(CONVERT_TZ(due_at, '+0:00', '#{pacific_offset}:00')) ASC, priority DESC, day_priority DESC, due_at ASC, created_at ASC"
  end

  def set_assignor
    if owner_id_changed?
      self.assigned_at = Time.now
      self.assignor_id = actor_id
    end
  end

  def service_ordinal_for_one_off
    if service
      service.tasks.maximum(:service_ordinal) || 0
    else
      nil
    end
  end

  def create_task_data_fields!
    task_template.task_data_field_templates.each do |task_data_field_template|
      task_data_fields.create!(task_data_field_template: task_data_field_template,
                               data_field: service.data_fields.find_by_data_field_template_id!(task_data_field_template.data_field_template_id))
    end
  end

  def create_task_steps!
    task_template.task_step_templates.each do |task_step_template|
      task_steps.create!(task_step_template: task_step_template)
    end
  end
end
