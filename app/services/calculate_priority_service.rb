class CalculatePriorityService
  def initialize(options)
    @task = options[:task]
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
    @priority = time_zone_score
  end


  def time_zone_score
    @time_zone_score ||=  if @task.time_zone_score
                            @task.time_zone_offset/3600
                          else
                            PST_HOUR_OFFSET = ActiveSupport::TimeZone.new("America/Los_Angeles").utc_offset/3600
                          end

end
