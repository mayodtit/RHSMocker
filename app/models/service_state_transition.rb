class ServiceStateTransition < ActiveRecord::Base
  belongs_to :service
  belongs_to :actor, class_name: 'Member'

  attr_accessible :created_at, :event, :from, :to, :actor, :actor_id

  validates :service, :created_at, :actor, presence: true
end
