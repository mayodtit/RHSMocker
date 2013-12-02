class ProgramResourceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :resource_id, :resource_type, :title

  private

  def title
    object.resource.title
  end
end
