class PhoneCallTaskSerializer < TaskSerializer

  attributes :consult, :type

  has_one :member

  def type
    'call'
  end
end
