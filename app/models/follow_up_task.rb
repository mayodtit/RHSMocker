class FollowUpTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :phone_call

  delegate :consult, to: :phone_call

  attr_accessible :phone_call_id, :phone_call

  validates :phone_call_id, presence: true
  validates :phone_call, presence: true, if: lambda { |t| t.phone_call_id }

  def member
    phone_call.user || (consult && consult.initiator)
  end

  def set_role
    self.role_id = Role.find_by_name!('pha').id
  end
end