class NewMemberTaskSerializer < TaskSerializer

  has_one :member

  def type
    'new-member'
  end
end