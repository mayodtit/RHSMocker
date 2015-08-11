class AppointmentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :provider_id, :scheduled_at, :provider, :creator_id, :arrived_at, :departed_at, :reason_for_visit, :special_instructions, :phone_number

  def phone_number
    object.phone_numbers.try(:first)
  end
end
