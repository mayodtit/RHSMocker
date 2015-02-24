class TaskChangeEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :task_id, :task, :event, :actor, :update_type, :update_data

  def task
    object.task.try(:entry_serializer).as_json
  end

  def event
    if object.event.nil?
      'created'
    elsif object.event == 'update'
      'updated'
    elsif object.event == 'unstart' && object.data && object.data.keys.first == "owner_id"
      'assigned'
    else
      object.to
    end
  end

  def actor
    object.actor.try(:full_name)
  end

  def update_type
    object.data && object.data.keys.first
  end

  def update_data
    object.data && object.data.values.first
  end
end
