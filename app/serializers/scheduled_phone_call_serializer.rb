class ScheduledPhoneCallSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :scheduled_at, :created_at, :updated_at, :state
  has_one :user
  has_one :owner
  has_one :phone_call
end
