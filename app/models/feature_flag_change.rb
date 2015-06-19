class FeatureFlagChange < ActiveRecord::Base
  belongs_to :feature_flag
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash
  attr_accessible :actor_id, :actor, :data, :feature_flag_id, :feature_flag, :action

  validates :feature_flag, :actor, :data, presence: true
  validates :action, :inclusion => {:in => ['add', 'update', 'destroy']}
end
