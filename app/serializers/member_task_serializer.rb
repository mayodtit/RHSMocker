class MemberTaskSerializer < TaskSerializer
  has_one :member
  has_one :subject
  has_one :creator

  def type
    'task'
  end
end
