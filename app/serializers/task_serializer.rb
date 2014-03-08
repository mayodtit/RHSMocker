class TaskSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :kind, :state, :description, :due_at,
             :consult_id, :message_id, :phone_call_id, :scheduled_phone_call_id,
             :phone_call_summary_id

  has_one :role
  has_one :member
end