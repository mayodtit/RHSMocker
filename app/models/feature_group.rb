class FeatureGroup < ActiveRecord::Base
  has_many :user_feature_groups
  has_many :users, :through => :user_feature_groups

  attr_accessible :name

  validates :name, presence: true, uniqueness: true
end
