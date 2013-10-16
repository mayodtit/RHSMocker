class FeatureGroup < ActiveRecord::Base
  has_many :user_feature_groups
  has_many :users, :through => :user_feature_groups
  serialize :metadata_override, Hash

  attr_accessible :name, :metadata_override

  validates :name, presence: true, uniqueness: true
end
