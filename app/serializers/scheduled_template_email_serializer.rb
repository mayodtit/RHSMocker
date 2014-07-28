class ScheduledTemplateEmailSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :sender_id, :recipient_id, :text, :state,
             :publish_at, :delivered_at, :created_at, :updated_at,
             :state_events

  def text
    object.template
  end
end
