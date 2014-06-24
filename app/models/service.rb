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

  attr_accessor :actor_id
  attr_accessible :description, :title, :service_type_id, :service_type,
                  :member_id, :member, :subject_id, :subject, :reason_abandoned,
                  :creator_id, :creator, :owner_id, :owner, :assignor_id, :assignor,
                  :actor_id, :due_at, :state_event, :service_template, :service_template_id

  validates :title, :service_type, :state, :member, :creator, :owner, :assignor, :assigned_at, presence: true
  validates :reason_abandoned, presence: true, if: lambda { |s| s.abandoned? }
  validates :service_template, presence: true, if: lambda { |s| s.service_template_id.present? }

  before_validation :set_assigned_at

  def set_assigned_at
    if owner_id_changed?
      self.assigned_at = Time.now
    end
  end

  state_machine :initial => :open do
    store_audit_trail context_to_log: :actor_id

    event :reopen do
      transition any => :open
    end

    event :complete do
      transition any => :completed
    end

    event :abandon do
      transition any => :abandoned
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
end
