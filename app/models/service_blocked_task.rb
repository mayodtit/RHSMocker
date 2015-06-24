class ServiceBlockedTask < Task
  PRIORITY = 100

  validates :service, presence: true

  after_save :unlock_service!, if: :completed?

  def set_priority
    self.priority = PRIORITY
  end

  private

  def unlock_service!
    service.reopen!
    service.reload.create_next_ordinal_tasks
  end
end
