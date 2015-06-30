class CarePortalSession < Session
  include TimeoutModule
  include ActiveModel::ForbiddenAttributesProtection

  TYPES = %i(pha specialist hcc nurse)
  symbolize :queue_mode, in: TYPES

  attr_accessible :queue_mode

  validates :queue_mode, presence: true
  validate :member_uniqueness, on: :create

  before_validation :set_defaults, on: :create
  before_validation :destroy_other_sessions, on: :create

  private

  def member_uniqueness
    if self.class.where(member_id: member_id).exists?
      errors.add(:member_id, "is already taken")
    end
  end

  def set_defaults
    self.disabled_at = 15.minutes.from_now
    self.queue_mode = default_queue_mode
  end

  def destroy_other_sessions
    self.class.where(member_id: member_id).destroy_all
  end

  def default_queue_mode
    if member.try(:nurse?)
      :nurse
    elsif last_mode = self.class.last_queue_mode(member)
      last_mode
    elsif member.try(:specialist?)
      :specialist
    elsif member.try(:hcc?)
      :hcc
    else
      :pha
    end
  end

  def self.last_queue_mode(member)
    return nil unless member
    unscoped.where(member_id: member.id).last.try(:queue_mode)
  end
end
