class Service < ActiveRecord::Base
  OPEN_STATES = %w(open waiting draft)
  CLOSED_STATES = %w(completed abandoned)

  belongs_to :service_type
  belongs_to :service_template
  has_many :data_fields, inverse_of: :service,
                         include: :data_field_template,
                         dependent: :destroy
  belongs_to :suggested_service, inverse_of: :service

  belongs_to :member, inverse_of: :services
  belongs_to :subject, class_name: 'User'

  belongs_to :creator, class_name: 'Member'
  belongs_to :owner, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :abandoner, class_name: 'Member'

  has_many :tasks, order: 'service_ordinal ASC, priority DESC, due_at ASC, created_at ASC',
                   dependent: :destroy
  has_many :member_tasks
  has_many :service_changes
  has_one :entry, as: :resource

  has_many :messages, inverse_of: :service
  has_many :scheduled_communications, inverse_of: :service

  attr_accessor :actor, :change_tracked, :reason, :pubsub_client_id
  attr_accessible :description, :title, :service_type_id, :service_type, :user_facing, :service_request, :service_deliverable,
                  :member_id, :member, :subject_id, :subject, :reason_abandoned, :reason, :abandoner, :abandoner_id,
                  :creator_id, :creator, :owner_id, :owner, :assignor_id, :assignor, :service_update, :time_zone,
                  :actor, :due_at, :state_event, :service_template, :service_template_id, :pubsub_client_id

  validates :title, :service_type, :state, :member, :subject, :creator, :owner, :assignor, :assigned_at, presence: true
  validates :user_facing, :inclusion => { :in => [true, false] }
  validates :service_template, presence: true, if: :service_template_id
  validates :suggested_service, presence: true, if: :suggested_service_id
  validate :no_placeholders_in_user_facing_attributes

  before_validation :reinitialize_state_machine, on: :create
  before_validation :set_defaults, on: :create
  before_validation :set_assigned_at
  after_create :create_data_fields!, if: :service_template
  after_create :create_next_ordinal_tasks
  after_save :create_service_blocked_task!, if: :waiting?
  after_commit :track_update, on: :update
  after_commit :publish

  def open?
    (OPEN_STATES.include? state)
  end

  def self.open_state
    where(state: OPEN_STATES)
  end

  def self.closed_state
    where(state: CLOSED_STATES)
  end

  def publish
    if id_changed?
      PubSub.publish "/members/#{member_id}/subjects/#{subject_id}/services/new", {id: id}, pubsub_client_id
    else
      PubSub.publish "/members/#{member_id}/subjects/#{subject_id}/services/update", {id: id}, pubsub_client_id
    end
  end

  def set_assigned_at
    if owner_id_changed?
      self.assigned_at = Time.now
    end
  end

  def create_next_ordinal_tasks(current_ordinal=-1, last_due_at=Time.now)
    return if waiting? || draft?
    return unless open? && service_template && tasks.open_state.empty?
    return if tasks.empty? && service_template.task_templates.empty?
    if next_ordinal = next_ordinal(current_ordinal)
      service_template.task_templates.where(service_ordinal: next_ordinal).each do |task_template|
        member_tasks.create!(task_template: task_template, start_at: service_template.timed_service? ? last_due_at : Time.now)
      end
    else
      self.complete!
    end
  end

  def next_ordinal(current_ordinal)
    return unless service_template
    service_template.task_templates.where('service_ordinal > ?', current_ordinal).minimum(:service_ordinal)
  end

  def calculated_next_state
    if completed? || abandoned?
      state.to_sym
    elsif open_conversations_with_member?
      :draft
    elsif missing_prerequisite_data?
      :waiting
    else
      :open
    end
  end

  def open_conversations_with_member?
    member.try(:message_tasks).try(:select, &:open?).try(:any?) || false
  end

  def missing_prerequisite_data?
    required_data_fields = data_fields.select(&:required_for_service_start)
    if required_data_fields.reject(&:data).any?
      true
    elsif service_template.nil?
      false
    elsif service_template.data_field_templates.select(&:required_for_service_start).count > required_data_fields.count
      true
    else
      false
    end
  end

  def calculated_state_event(next_state)
    case next_state
    when :open
      :reopen
    when :waiting
      :wait
    when :completed
      :complete
    when :abandoned
      :abandon
    else
      nil
    end
  end

  def auto_transition!
    next_state = calculated_next_state
    return if state?(next_state)
    state_event = calculated_state_event(next_state)
    update_attributes!(state_event: state_event) if state_event
  end

  state_machine initial: ->(s) { s.calculated_next_state } do
    store_audit_trail to: 'ServiceChange', context_to_log: %i(actor data reason)

    event :reset do
      transition any => :draft
    end

    event :wait do
      transition any => :waiting
    end

    event :reopen do
      transition any => :open
    end

    event :complete do
      transition any => :completed
    end

    event :abandon do
      transition any => :abandoned
    end

    before_transition any - :completed => :completed do |service|
      service.completed_at = Time.now
    end

    before_transition any - :abandoned => :abandoned do |service|
      service.abandoned_at = Time.now
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

  def data
    changes = previous_changes.except(
        :state,
        :created_at,
        :updated_at,
        :assigned_at,
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
      service_changes.create!(actor: actor, event: 'update', data: _data, reason: reason)
    end
  end

  private

  # call initialize twice to make sure dynamic initial state is set correctly
  def reinitialize_state_machine
    initialize_state_machines(dynamic: :force)
  end

  def set_defaults
    self.service_template ||= suggested_service.try(:suggested_service_template).try(:service_template)
    self.member ||= suggested_service.try(:user)
    self.title ||= suggested_service.try(:title) || service_template.try(:title)
    self.description ||= service_template.try(:description)
    self.service_type ||= service_template.try(:service_type) || suggested_service.try(:service_type)
    self.due_at ||= service_template.try(:calculated_due_at)
    self.service_update ||= service_template.try(:service_update)
    self.user_facing = service_template.try(:user_facing) if user_facing.nil?
    self.subject ||= member
    self.owner ||= member.try(:pha)
    self.creator ||= actor
    self.assignor ||= creator
    self.time_zone ||= member.try(:time_zone)
    self.time_zone_offset = ActiveSupport::TimeZone.new(time_zone).try(:utc_offset) if time_zone
    true
  end

  def no_placeholders_in_user_facing_attributes
    %i(title service_request service_deliverable).each do |attribute|
      if send(attribute).try(:match, RegularExpressions.braces)
        errors.add(attribute, "shouldn't contain placeholder text")
      elsif send(attribute).try(:match, RegularExpressions.brackets)
        errors.add(attribute, "shouldn't contain placeholder text")
      end
    end
  end

  def create_data_fields!
    service_template.data_field_templates.each do |data_field_template|
      data_fields.create!(data_field_template: data_field_template)
    end
  end

  def create_service_requirements_task!
    return if service_requirements_task
  end

  def create_service_blocked_task!
    return if ServiceBlockedTask.where(service_id: id).open_state.any?
    ServiceBlockedTask.create!(service: self, title: 'Unblock service', due_at: Time.now)
  end
end
