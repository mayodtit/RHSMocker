class MemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :member
  belongs_to :subject, class_name: 'User'

  attr_accessible :member_id, :member, :subject_id, :subject

  validates :member, presence: true
  validates :subject, presence: true
end
