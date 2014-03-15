class PhoneCallSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :created_at, :updated_at, :origin_phone_number,
             :destination_phone_number, :state, :claimed_at, :ended_at,
             :claimer_id, :ender_id, :identifier_token, :to_role_id,
             :dialer_id, :dialed_at, :resolver, :resolved_at,
             :destination_twilio_sid, :origin_twilio_sid,
             :transferred_to_phone_call_id, :missed_at, :transferrer_id,
             :transferred_at, :twilio_conference_name, :origin_status,
             :destination_status, :outbound, :to_role_name, :consult_id,
             :cp_connected?, :member_connected?

  has_one :user
  has_one :transferred_to_phone_call

  def consult_id
    object.consult && object.consult.id
  end

  def to_role_name
    case object.to_role
    when 'pha'
      object.to_role.name.upcase
    when 'nurse'
      'Nurseline'
    else
      nil
    end
  end
end
