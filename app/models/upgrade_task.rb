class UpgradeTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 6

  validates :member, presence: true

  def set_priority
    self.priority = PRIORITY
  end
end
