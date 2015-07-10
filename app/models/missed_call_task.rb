class MissedCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :phone_call

  attr_accessible :phone_call, :phone_call_id

  validates :phone_call, presence: true

  delegate :consult, to: :phone_call

  private

  def set_defaults
    self.member ||= phone_call.try(:user)
    self.owner ||= member.try(:pha)
    self.role = Role.pha
    super
  end
end
