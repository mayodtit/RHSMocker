class UpgradeTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true

  private

  def default_queue
    :hcc
  end

  def set_defaults
    self.priority ||= 6
    super
  end
end
