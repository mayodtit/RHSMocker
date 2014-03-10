class MessageTaskSerializer < TaskSerializer

  attributes :consult_id, :message_id, :type

  has_one :member

  def type
    'message'
  end
end