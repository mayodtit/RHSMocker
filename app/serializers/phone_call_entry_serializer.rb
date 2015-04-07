class PhoneCallEntrySerializer < ActiveModel::Serializer
  self.root = false
  attributes :member, :creator, :claimer, :origin_phone_number, :destination_phone_number, :state

  def member
    object.user.try(:full_name)
  end

  def claimer
    object.claimer.try(:full_name)
  end

  def creator
    object.creator.try(:full_name)
  end
end
