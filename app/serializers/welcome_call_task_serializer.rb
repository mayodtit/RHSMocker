class WelcomeCallTaskSerializer < TaskSerializer

  attributes :scheduled_phone_call, :member_id, :owner_id

  def type
    'welcome-call'
  end
end
