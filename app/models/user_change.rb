class UserChange < ActiveRecord::Base
  belongs_to :user
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash
  attr_accessible :actor_id, :actor, :data, :user_id, :user, :action

  validates :user, :actor, :data, presence: true
  validates :action, :inclusion => {:in => ['add', 'update', 'destroy']}
end
