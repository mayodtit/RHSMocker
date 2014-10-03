class MissedCallTaskSerializer < TaskSerializer

  attributes :phone_call_id, :message_id

  def message_id
    object.phone_call && object.phone_call.message && object.phone_call.message.id
  end

  def type
    'follow-up'
  end
end