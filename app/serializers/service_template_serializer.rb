class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id,
              :time_estimate, :due_at, :user_facing, :service_request,
              :service_update, :version, :unique_id, :state, :state_events,
              :created_at, :unpublished_version_id, :timed_service

  delegate :id, :title, :description, :service_type, :service_type_id,
           :time_estimate, :unique_id, :published?, :task_templates,
           to: :object

  def attributes
    if options[:shallow]
      {
         id: id,
         title: title,
         description: description,
         service_type_id: service_type_id,
         time_estimate: time_estimate,
         due_at: due_at
      }
    else
      super.tap do |attrs|
        attrs[:service_type] = service_type
        attrs[:task_templates] = task_templates.try(:serializer, shallow: true)
      end
    end
  end

  private

  def due_at
    if time_estimate
      Time.now.business_minutes_from(time_estimate)
    else
      Time.now
    end
  end

  def unpublished_version_id
    return nil unless unique_id && published?
    if unpublished_template = ServiceTemplate.unpublished.find_by_unique_id(unique_id)
      unpublished_template.id
    else
      nil
    end
  end
end
