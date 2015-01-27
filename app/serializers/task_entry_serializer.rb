class TaskEntrySerializer < ActiveModel::Serializer
  self.root = false
  attributes :title, :due_at, :description, :member, :creator, :owner, :service_type

  def member
    object.member.full_name
  end

  def creator
    object.creator.full_name
  end

  def owner
    object.owner.full_name
  end

  def service_type
    object.service_type.name
  end
end
