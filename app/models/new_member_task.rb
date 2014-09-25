class NewMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :member

  attr_accessible :member_id, :member

  validates :member_id, presence: true
  validates :member, presence: true, if: lambda { |t| t.member_id }

  before_validation :set_owner, on: :create
  before_validation :set_due_at, on: :create

  def set_due_at
    return if due_at.present?

    now = Time.now.in_time_zone('Pacific Time (US & Canada)')
    if Role.pha.during_on_call? now
      self.due_at = now.change hour: 18
    else
      if now.wday == 0 || now.wday == 6
        self.due_at = now.change(hour: ON_CALL_START_HOUR).next_wday 1
      elsif now.hour > (ON_CALL_END_HOUR - 1)
        self.due_at = (now + 1.day).change hour: 12
      else
        self.due_at = now.change hour: 18
      end
    end
  end
end
