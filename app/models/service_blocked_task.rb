class ServiceBlockedTask < Task
  validates :service, presence: true

  after_save :unlock_service!, if: :completed?

  private

  def set_defaults
    self.priority ||= 100
    super
  end

  def unlock_service!
    service.reopen!
    service.reload.create_next_ordinal_tasks
  end
end
