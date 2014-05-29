class Task < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :role, class_name: 'Role'
  belongs_to :owner, class_name: 'Member'
  belongs_to :creator, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'
  belongs_to :abandoner, class_name: 'Member'
  belongs_to :service_type

  attr_accessible :title, :description, :due_at, :reason_abandoned,
                  :owner, :owner_id, :member, :member_id,
                  :subject, :subject_id, :creator, :creator_id, :assignor, :assignor_id,
                  :abandoner, :abandoner_id, :role, :role_id,
                  :state_event, :service_type_id, :service_type

  validates :title, :state, :creator_id, :role_id, presence: true
  validates :owner, presence: true, if: lambda { |t| t.owner_id }
  validates :role, presence: true, if: lambda { |t| t.role_id }
  validates :service_type, presence: true, if: lambda { |t| t.service_type_id }
  validate :attrs_for_states
  validate :one_claimed_per_owner

  before_validation :set_role, on: :create

  after_save :publish
  after_save :notify

  scope :nurse, -> { where(['role_id = ?', Role.find_by_name!('nurse').id]) }
  scope :pha, -> { where(['role_id = ?', Role.find_by_name!('pha').id]) }
  scope :unassigned_and_owned, -> (hcp) { where(['state = ? OR (state IN (?, ?) AND owner_id = ?)', :unassigned, :assigned, :started, hcp.id]) }

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

  def set_role
    self.role_id = Role.find_by_name!(:pha).id if role_id.nil?
  end

  def notify
    if unassigned?
      UserMailer.delay.notify_phas_of_new_task if for_pha?
    end
  end

  def publish
    if id_changed?
      PubSub.publish "/tasks/new", { id: id }
    else
      PubSub.publish "/tasks/update", { id: id }
      PubSub.publish "/tasks/#{id}/update", { id: id }
    end

    if owner_id.present?
      PubSub.publish "/users/#{owner_id}/tasks/owned/update", { id: id }
    end

    if owner_id_changed? && owner_id_was
      PubSub.publish "/users/#{owner_id_was}/tasks/owned/update", { id: id }
    end
  end

  state_machine :initial => :unassigned do
    event :unassign do
      transition any => :unassigned
    end

    event :assign do
      transition any => :assigned
    end

    event :start do
      transition any => :started
    end

    event :claim do
      transition any - [:claimed] => :claimed
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
    end

    before_transition any => :assigned do |task|
      task.assigned_at = Time.now
    end

    before_transition any => :started do |task|
      task.started_at = Time.now
    end

    before_transition any => :claimed do |task|
      task.claimed_at = Time.now
    end

    before_transition any => :completed do |task|
      task.completed_at = Time.now
    end

    before_transition any => :abandoned do |task|
      task.abandoned_at = Time.now
    end

    before_transition :abandoned => any do |task|
      task.reason_abandoned = nil
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
        errors.add(:state, "cannot claim more than one task.")
      end
    end
  end
end
