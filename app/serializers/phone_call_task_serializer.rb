class PhoneCallTaskSerializer < TaskSerializer

  attributes :phone_call_id

  has_one :member

  def type
    'call'
  end
end
