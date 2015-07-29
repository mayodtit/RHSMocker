class AppointmentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :provider_id, :scheduled_at, :provider, :creator_id
end
