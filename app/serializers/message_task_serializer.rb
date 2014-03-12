class MessageTaskSerializer < TaskSerializer

  attributes :consult_id, :message_id

  has_one :member

  def type
    'message'
  end
end