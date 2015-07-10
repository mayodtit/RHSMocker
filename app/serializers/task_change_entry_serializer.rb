class TaskChangeEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :service_id, :service_title, :task_id, :task, :event, :actor, :update_type, :update_data

  def task
    object.task.try(:entry_serializer).as_json
  end

  def service_id
    object.task.try(:service_id)
  end

  def service_title
    object.task.service.try(:title) if object.task.respond_to? :service
  end

  def event
    if object.event.nil?
      'created'
    elsif object.event == 'update'
      'updated'
    elsif object.event == 'update' && object.data && object.data.keys.first == "owner_id"
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
