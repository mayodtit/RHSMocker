class UserFeatureGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :feature_group

  attr_accessible :user, :feature_group

  validates :user, :feature_group, presence: true
  validates :feature_group_id, :uniqueness => {:scope => :user_id}
end
