class CalculatePriorityService
  def initialize(options)
    @task = options[:task]
    @service = options[:service]
  end

  def call
    raise "Task not included in options" unless (@task)
    {
      priority: priority,
    }
  end

  private

  def priority
    #Put the Magic here
    @priority ||= 5
  end
end
