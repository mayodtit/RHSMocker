class NewMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :member

  validates :member, presence: true

  private

  def set_defaults
    self.owner ||= member.try(:pha)
    self.due_at ||= calculate_due_at
    super
  end

  def calculate_due_at
    now = Time.now.pacific

    if Role.pha.during_on_call? now
      return now.change hour: 18
    elsif now.wday == 0 || now.wday == 6
      return now.change(hour: ON_CALL_START_HOUR).next_wday 1
    elsif now.hour > (ON_CALL_END_HOUR - 1)
      return (now + 1.day).change hour: 12
    end

    now.change hour: 18
  end
end
