class PhoneCallTaskSerializer < TaskSerializer

  attributes :phone_call_id, :transferrer

  has_one :member

  def transferrer
    object.phone_call.transferred_from_phone_call && MemberSerializer.new(object.phone_call.transferred_from_phone_call.claimer)
  end

  def type
    'call'
  end
end
