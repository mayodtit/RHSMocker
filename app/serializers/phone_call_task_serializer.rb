class PhoneCallTaskSerializer < TaskSerializer

  attributes :phone_call_id, :transferrer

  def attributes
    if options[:shallow]
      super.tap do |attributes|
        attributes[:transferrer] = transferrer
      end
    else
      super
    end
  end

  def transferrer
    object.phone_call.transferred_from_phone_call && object.phone_call.transferred_from_phone_call.claimer.serializer(options)
  end

  def type
    'call'
  end
end
