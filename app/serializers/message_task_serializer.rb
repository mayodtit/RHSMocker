class MessageTaskSerializer < TaskSerializer

  attributes :consult_id, :message_id

  def type
    'message'
  end
end