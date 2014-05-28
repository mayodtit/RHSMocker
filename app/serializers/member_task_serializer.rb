class MemberTaskSerializer < TaskSerializer
  attributes :member_id, :subject_id

  has_one :member
  has_one :subject
  has_one :creator

  def type
    'task'
  end
end
