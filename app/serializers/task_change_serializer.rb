class TaskChangeSerializer < ActiveModel::Serializer
  attributes  :created_at, :event, :from, :to, :actor, :data
end
