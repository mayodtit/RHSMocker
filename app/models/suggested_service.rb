class SuggestedService < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :suggested_service_template
  has_one :service, inverse_of: :suggested_service
  has_many :suggested_service_changes, inverse_of: :suggested_service
  attr_accessor :actor

  attr_accessible :user, :user_id, :suggested_service_template, :suggested_service_template_id, :user_facing, :actor, :state_event

  validates :user, :suggested_service_template, presence: true
  validates :user_facing, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create
  after_update :track_changes!

  delegate :title, :description, :message, to: :suggested_service_template

  protected

  def user_facing_is_false
    errors.add(:user_facing, 'must be false') if user_facing
  end

  def unset_user_facing
    self.user_facing = false if user_facing
    true
  end

  def create_accepted_service
    create_service!(actor: actor)
  end

  private

  state_machine initial: :unoffered do
    store_audit_trail to: 'SuggestedServiceChange', context_to_log: :actor

    state :unoffered, :accepted, :rejected, :expired do
      validate ->(s) { s.user_facing_is_false }
    end

    event :offer do
      transition :unoffered => :offered
    end

    event :accept do
      transition all - :accepted => :accepted
    end

    event :reject do
      transition all - :rejected => :rejected
    end

    event :expire do
      transition %i(unoffered offered) => :expired
    end

    before_transition any => any - :offered, do: :unset_user_facing
    after_transition any - :accepted => :accepted, do: :create_accepted_service
  end

  def set_defaults
    self.user_facing = false if user_facing.nil?
    true
  end

  def track_changes!
    if changes_to_track.any?
      suggested_service_changes.create!(actor: actor, data: changes_to_track)
    end
  end

  def changes_to_track
    changes.slice(:user_facing)
  end
end
