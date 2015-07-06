class UpgradeTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true

  private

  def set_defaults
    self.priority ||= 6
    super
  end
end
