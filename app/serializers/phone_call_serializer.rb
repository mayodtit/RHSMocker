class PhoneCallSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :created_at, :origin_phone_number,
             :destination_phone_number, :state, :identifier_token,
             :destination_twilio_sid, :origin_twilio_sid,
             :transferred_to_phone_call_id,  :consult_id, :cp_connected?,
             :member_connected?, :transferred?, :outbound?, :transferred_to_phone_call,
             :transferred_from_phone_call, :claimer, :user

  def consult_id
    object.consult && object.consult.id
  end

  def user
    MemberSerializer.new(object.user)
  end

  def claimer
    MemberSerializer.new(object.claimer)
  end

  def transferred_to_phone_call
    PhoneCallSerializer.new(object.transferred_to_phone_call, except: :transferred_from_phone_call)
  end

  def transferred_from_phone_call
    PhoneCallSerializer.new(object.transferred_from_phone_call, except: :transferred_to_phone_call)
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
