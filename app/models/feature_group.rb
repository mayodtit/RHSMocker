class FeatureGroup < ActiveRecord::Base
  has_many :user_feature_groups, dependent: :destroy
  has_many :users, through: :user_feature_groups
  serialize :metadata_override, Hash

  attr_accessible :name, :metadata_override, :premium, :free_trial_days,
                  :free_trial_ends_at

  validates :name, presence: true, uniqueness: true
  validates :premium, inclusion: {in: [true, false]}

  def free_trial_days
    read_attribute(:free_trial_days) || 0
  end
end
