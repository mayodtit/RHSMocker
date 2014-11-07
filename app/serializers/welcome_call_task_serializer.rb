class WelcomeCallTaskSerializer < TaskSerializer

  attributes :scheduled_phone_call, :member_id, :owner_id

  def attributes
    if options[:shallow]
      super.tap do |attributes|
        attributes[:scheduled_phone_call] = object.scheduled_phone_call
      end
    else
      super
    end
  end

  def type
    'welcome-call'
  end
end
