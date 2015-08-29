class ServiceTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes  :id, :name, :title, :description, :service_type_id,
              :time_estimate, :due_at, :user_facing, :service_request,
              :service_update, :version, :unique_id, :state, :state_events,
              :created_at, :unpublished_version_id, :timed_service

  has_one :service_type
  has_many :task_templates
  has_many :task_template_sets
  has_many :data_field_templates

  delegate :time_estimate, :unique_id, :published?, to: :object

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
