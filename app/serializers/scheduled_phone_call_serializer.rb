class ScheduledPhoneCallSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :scheduled_at, :created_at, :updated_at, :state, :state_events
  has_one :user
  has_one :owner
end
