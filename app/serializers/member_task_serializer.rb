class MemberTaskSerializer < TaskSerializer
  has_one :member
  has_one :subject

  def type
    'task'
  end
end
