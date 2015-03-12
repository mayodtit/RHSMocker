class Service < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :service_type
  belongs_to :service_template

  belongs_to :member
  belongs_to :subject, class_name: 'User'

  belongs_to :creator, class_name: 'Member'
  belongs_to :owner, class_name: 'Member'
  belongs_to :assignor, class_name: 'Member'

  has_many :service_state_transitions
  has_many :tasks, order: 'service_ordinal ASC, priority DESC, due_at ASC, created_at ASC'
  has_many :service_changes, order: 'created_at DESC'

  attr_accessor :actor_id, :change_tracked, :reason
  attr_accessible :description, :title, :service_type_id, :service_type,
                  :member_id, :member, :subject_id, :subject, :reason_abandoned,
                  :creator_id, :creator, :owner_id, :owner, :assignor_id, :assignor,
                  :actor_id, :due_at, :state_event, :service_template, :service_template_id

  validates :title, :service_type, :state, :member, :creator, :owner, :assignor, :assigned_at, presence: true
  validates :service_template, presence: true, if: lambda { |s| s.service_template_id.present? }

  before_validation :set_assigned_at

  after_commit :track_update, on: :update

  def set_assigned_at
    if owner_id_changed?
      self.assigned_at = Time.now
    end
  end

  def create_next_ordinal_tasks(current_ordinal = -1, start_time = Time.now)
    return unless service_template && tasks.open_state.empty?
    if next_ordinal = next_ordinal(current_ordinal)
      service_template.task_templates.where(service_ordinal: next_ordinal).each do |task_template|
        task_template.create_task!(service: self, start_at: service_template.timed_service ? start_time : Time.now, assignor: assignor)
      end
    end
  end

  def next_ordinal(current_ordinal)
    return unless service_template
    service_template.task_templates.where('service_ordinal > ?', current_ordinal).minimum(:service_ordinal)
  end

  state_machine :initial => :open do
    store_audit_trail to: 'ServiceChange', context_to_log: %i(actor_id data reason)

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

    after_transition any => any do |service|
      service.change_tracked = true
    end
  end

  def actor_id
    if @actor_id.nil?
      if owner_id.nil?
        creator_id
      else
        owner_id
      end
    else
      @actor_id
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
      ServiceChange.create! service: self, actor_id: self.actor_id, event: 'update', data: _data, reason: reason
    end
  end
end
