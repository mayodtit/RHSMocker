class UpgradeTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 9

  attr_accessible :member, :member_id

  validates :member, presence: true

  def set_priority
    self.priority = PRIORITY
  end
end
