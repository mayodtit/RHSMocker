class ServiceChangeEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :service_id, :service, :event, :actor, :update_type, :update_data

  def service
    object.service.try(:entry_serializer).as_json
  end

  def event
    if object.event.nil?
      'created'
    elsif object.event == 'update'
      'updated'
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
