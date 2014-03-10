class MessageTaskSerializer < TaskSerializer

  attributes :consult, :type

  has_one :member

  def type
    'message'
  end
end