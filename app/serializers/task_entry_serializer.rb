class TaskEntrySerializer < ActiveModel::Serializer
  self.root = false
  attributes :title, :due_at, :description, :member, :creator, :owner, :service_type

  def member
    object.member.try(:full_name)
  end

  def creator
    object.creator.try(:full_name)
  end

  def owner
    object.owner.try(:full_name)
  end

  def service_type
    object.service_type.try(:name)
  end
end
