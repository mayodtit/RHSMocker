class ScheduledCommunicationSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :sender_id, :recipient_id, :state, :publish_at,
             :delivered_at, :created_at, :updated_at, :state_events,
             :type
end
