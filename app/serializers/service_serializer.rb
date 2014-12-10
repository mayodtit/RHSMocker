class ServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :state, :description, :due_at, :service_type_id, :created_at, :owner_id

  def attributes
    super.tap do |attributes|
      attributes[:tasks] = object.tasks.try(:serializer, options.merge(shallow: true)) if object.respond_to? :tasks
    end
  end

end