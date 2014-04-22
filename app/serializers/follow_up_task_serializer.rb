class FollowUpTaskSerializer < TaskSerializer

  attributes :phone_call_id

  has_one :member

  def type
    'follow-up'
  end
end