class ScheduledMessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :sender_id, :consult_id, :message_id, :text, :state,
             :publish_at, :delivered_at, :created_at, :updated_at,
             :state_events
end
