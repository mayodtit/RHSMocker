class PhoneCallTaskSerializer < TaskSerializer

  attributes :phone_call_id, :message_id, :transferrer

  def attributes
    if options[:shallow]
      super.tap do |attributes|
        attributes[:phone_call_id] = object.phone_call_id
        attributes[:transferrer] = transferrer
      end
    else
      super
    end
  end

  def transferrer
    object.phone_call.transferred_from_phone_call && object.phone_call.transferred_from_phone_call.claimer.try(:serializer, options)
  end

  def message_id
    object.phone_call.message && object.phone_call.message.id
  end

  def type
    'call'
  end
end
