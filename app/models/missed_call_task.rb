class MissedCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :phone_call

  delegate :consult, to: :phone_call

  attr_accessible :phone_call_id, :phone_call

  validates :phone_call_id, presence: true
  validates :phone_call, presence: true, if: lambda { |t| t.phone_call_id }

  before_validation :set_owner, on: :create
  before_validation :set_member

  def set_member
    self.member = phone_call.user if member.nil? && phone_call.present?
  end

  def set_role
    self.role_id = Role.find_by_name!('pha').id
  end
end
