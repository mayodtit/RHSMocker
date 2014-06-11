class NewMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :member

  attr_accessible :member_id, :member

  validates :member_id, presence: true
  validates :member, presence: true, if: lambda { |t| t.member_id }

  before_validation :set_owner, on: :create
end
