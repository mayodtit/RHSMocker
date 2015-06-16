class FeatureFlag < Metadata

  has_many :feature_flag_changes

  attr_accessor :actor_id
  attr_accessible :description, :actor_id, :disabled_at, :enabled

  validates :actor_id, presence: true, on: :update

  after_save :track_update, on: :update

  def enabled=(value)
    self.mvalue = value ? "true" : "false"
  end

  def enabled?
    mvalue == 'true'
  end

  def actor_id
    @actor_id || Member.robot.id
  end

  def track_update
    changes = self.changes.except(:created_at, :updated_at)
    return if changes.empty?
    @actor_id ||= Member.robot.id
    FeatureFlagChange.create! feature_flag: self, actor_id: actor_id, action: 'update', data: changes
  end
end
