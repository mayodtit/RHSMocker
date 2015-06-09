class FeatureFlag < Metadata

  has_many :feature_flag_changes

  attr_accessible :description

  after_save :track_update, on: :update

  def feature_enabled?
    mvalue == 'true'
  end

  def track_update
    changes = self.changes.except(:created_at, :updated_at, :avatar)
    return if changes.empty?
    @actor_id ||= Member.robot.id
    FeatureFlagChange.create! feature_flag: self, actor_id: actor_id, action: 'update', data: changes
  end
end
