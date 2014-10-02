class UpgradeTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 6

  belongs_to :member
  attr_accessible :member, :member_id

  validates :member, presence: true

  def set_priority
    self.priority = PRIORITY
  end
end
