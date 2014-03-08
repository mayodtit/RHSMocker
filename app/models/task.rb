class Task < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :role, class_name: 'Role'
  belongs_to :owner, class_name: 'Member'
  belongs_to :member, class_name: 'Member'
  belongs_to :subject, class_name: 'Member'

  belongs_to :creator, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :abandoner, class_name: 'Member'

  belongs_to :consult, class_name: 'Consult'
  belongs_to :phone_call, class_name: 'PhoneCall'
  belongs_to :scheduled_phone_call, class_name: 'ScheduledPhoneCall'
  belongs_to :message, class_name: 'Message'
  belongs_to :phone_call_summary, class_name: 'PhoneCallSummary'

  attr_accessible :title, :description, :kind, :due_at, :reason_abandoned,
                  :owner, :owner_id, :member, :member_id,
                  :subject, :subject_id, :creator, :creator_id, :assignor, :assignor_id,
                  :abandoner, :abandoner_id,
                  :role, :role_id, :consult, :consult_id, :phone_call, :phone_call_id,
                  :scheduled_phone_call, :scheduled_phone_call_id, :message, :message_id,
                  :phone_call_summary, :phone_call_summary_id,
                  :state_event

  validates :title, :kind, :state, :creator_id, :role_id, presence: true, allow_blank: false
  validates :owner, presence: true, if: lambda { |t| t.owner_id }
  validates :member, presence: true, if: lambda { |t| t.member_id }
  validates :subject, presence: true, if: lambda { |t| t.subject_id }
  validates :role, presence: true, if: lambda { |t| t.role_id }
  validates :consult, presence: true, if: lambda { |t| t.consult_id }
  validates :phone_call, presence: true, if: lambda{ |t| t.phone_call_id }
  validates :scheduled_phone_call, presence: true, if: lambda { |t| t.scheduled_phone_call_id }
  validates :message, presence: true, if: lambda { |t| t.message_id }
  validates :phone_call_summary, presence: true, if: lambda { |t| t.phone_call_summary_id }
  validate :attrs_for_states
  validate :one_claimed_per_owner
  validate :one_message_per_consult

  before_validation :set_role, on: :create
  before_validation :set_kind, on: :create

  after_save :publish

  def open?
    !(%w(completed abandoned).include? state)
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

  def self.messages_for_consult(consult_id)
    where('consult_id = ? AND kind = ?', consult_id, 'message')
  end

  def self.create_unique_open_message_for_consult!(consult, message = nil)
    if Task.open.messages_for_consult(consult.id).count == 0
      self.create!(title: consult.title, consult: consult, message: message, creator: Member.robot)
    end
  end

  def set_role
    self.role_id = Role.find_by_name!(:pha).id if role_id.nil?
  end

  def set_kind
    if kind.nil?
      if message_id.present?
        self.kind = 'message'
      elsif phone_call_id.present?
        self.kind = 'call'
      elsif scheduled_phone_call_id.present?
        self.kind = 'appointment'
      elsif phone_call_summary_id.present?
        self.kind = 'follow_up'
      elsif consult_id.present? && creator_id == Member.robot.id
        self.kind = 'message'
      elsif consult_id.present?
        self.kind = 'consult'
      elsif member_id.present?
        self.kind = 'member'
      else
        self.kind = 'misc'
      end
    end
  end

  def publish
    if id_changed?
      PubSub.publish "/tasks/new", { id: id }
    else
      PubSub.publish "/tasks/update", { id: id }
      PubSub.publish "/tasks/#{id}/update", { id: id }
    end
  end

  state_machine :initial => :unassigned do
    event :unassign do
      transition [:assigned, :started, :claimed] => :unassigned
    end

    event :assign do
      transition [:assigned, :unassigned] => :assigned
    end

    event :start do
      transition any => :started
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

    before_transition any => :unassigned do |task|
      task.assignor = nil
      task.owner = nil
      if task.phone_call && task.kind == 'call'
        task.phone_call.update_attributes!(state_event: :unclaim)
      end
    end

    before_transition any => :assigned do |task|
      task.assigned_at = Time.now
    end

    before_transition any => :started do |task|
      task.started_at = Time.now
    end

    before_transition any => :claimed do |task|
      task.claimed_at = Time.now
      if task.phone_call && task.kind == 'call' && !task.phone_call.claimed?
        task.phone_call.update_attributes!(state_event: :claim, claimer: task.owner)
      end
    end

    before_transition any => :completed do |task|
      task.completed_at = Time.now
      if task.phone_call && task.kind == 'call' && task.phone_call.in_progress?
        task.phone_call.update_attributes!(state_event: :end, ender: task.owner)
      end
    end

    before_transition any => :abandoned do |task|
      task.abandoned_at = Time.now
      if task.phone_call && task.kind == 'call' && task.phone_call.in_progress?
        task.phone_call.update_attributes!(state_event: :end, ender: task.abandoner)
      end
    end
  end

  # TODO: Write more comprehensive tests
  def attrs_for_states
    case state
      when 'assigned'
        validate_actor_and_timestamp_exist :assign
      when 'started'
        validate_timestamp_exists :start
      when 'claimed'
        validate_timestamp_exists :claim
      when 'completed'
        validate_timestamp_exists :complete
      when 'abandoned'
        validate_actor_and_timestamp_exist :abandon
        if reason_abandoned.nil? || reason_abandoned.blank?
          errors.add(:reason_abandoned, "must be present when #{self.class.name} is #{state}")
        end
    end

    if %w(assigned started claimed completed).include? state
      if owner_id.nil?
        errors.add(:owner_id, "must be present when #{self.class.name} is #{state}")
      end
    end
  end

  def one_claimed_per_owner
    if state == 'claimed'
      task = Task.find_by_owner_id_and_state(owner_id, 'claimed')
      if task && task.id != id
        errors.add(:state, "cannot be 'claimed' for more than one task")
      end
    end
  end

  def one_message_per_consult
    if kind == 'message' && open?
      task = Task.open.messages_for_consult(consult_id).first
      if task && task.id != id
        errors.add(:kind, "cannot be 'message' for consult #{consult_id} when another uncompleted 'message' task exists")
      end
    end
  end
end
