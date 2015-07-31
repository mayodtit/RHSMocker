class ServiceBlockedTaskSerializer < TaskSerializer
  delegate :service, to: :object

  def task_steps
    [
      {
        description: "Fill in missing Service data",
        completed: false,
        data_fields: data_fields
      }
    ]
  end

  def data_fields
    service.data_fields.select(&:required_for_service_start).serializer.as_json.each do |data_field|
      data_field[:required] = true
    end
  end
end
