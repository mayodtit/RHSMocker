class SuggestedService < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :suggested_service_template, inverse_of: :suggested_services
  belongs_to :service_type, inverse_of: :suggested_services
  has_one :service, inverse_of: :suggested_service
  has_many :suggested_service_changes, inverse_of: :suggested_service
  attr_accessor :actor

  attr_accessible :user, :user_id, :suggested_service_template, :suggested_service_template_id, :service_type, :service_type_id, :user_facing, :actor, :state_event, :title, :description, :message

  validates :user, :title, :description, presence: true
  validates :message, presence: true, if: :user_facing
  validates :user_facing, inclusion: {in: [true, false]}
  validate :suggested_service_template_or_service_type

  before_validation :set_defaults, on: :create
  after_update :track_changes!

  def title
    read_attribute(:title) || suggested_service_template.try(:title)
  end

  def description
    read_attribute(:description) || suggested_service_template.try(:description)
  end

  def message
    read_attribute(:message) || suggested_service_template.try(:message)
  end

  protected

  def user_facing_is_false
    errors.add(:user_facing, 'must be false') if user_facing
  end

  def unset_user_facing
    self.user_facing = false if user_facing
    true
  end

  def create_accepted_service
    create_service!(actor: actor) unless service
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

  def suggested_service_template_or_service_type
    if suggested_service_template && service_type
      errors.add(:base, 'only one of suggested service template or service type may be present')
    elsif !suggested_service_template && !service_type
      errors.add(:base, 'suggested service template or service type must be present')
    end
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
