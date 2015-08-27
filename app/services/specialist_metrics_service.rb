class SpecialistMetricsService
  def initialize(specialist)
    @specialist = specialist
  end

  def call
    raise "specialist not specified" unless (@specialist)
    metrics
  end

  private

  def tasks
    @tasks = Task.where(owner_id: @specialist.id)
  end

  def tasks_completed_today
    @tasks_completed_today = tasks.where('completed_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now.end_of_day)
  end

  def tasks_completed_this_week
    tasks.where('completed_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week)
  end

  def calculate_average_time_of_completion(completed_tasks)
    if completed_tasks.empty?
      0
    else
      completed_at_array = completed_tasks.pluck(:completed_at)
      completed_at_sum = completed_at_array.inject(0) do |sum, element|
        sum += element.to_i
      end
      claimed_at_array = completed_tasks.pluck(:claimed_at)
      claimed_at_sum = claimed_at_array.inject(0) do |sum, element|
        sum += element.to_i
      end
      ((completed_at_sum-claimed_at_sum)/completed_tasks.count/60).to_i
    end
  end

  def average_time_of_completion_today
    @average_time_of_completion_today = calculate_average_time_of_completion(tasks_completed_today)
  end

  def average_time_of_completion_this_week
    @average_time_of_completion_today = calculate_average_time_of_completion(tasks_completed_this_week)
  end

  def metrics
    @metrics = {}
    @metrics.merge!(number_of_tasks_completed_today: tasks_completed_today.count)
    @metrics.merge!(number_of_tasks_blocked_internally_today: tasks.where('blocked_internal_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now.end_of_day).count)
    @metrics.merge!(number_of_tasks_blocked_externally_today: tasks.where('blocked_external_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now.end_of_day).count)
    @metrics.merge!(average_time_of_completion_today: average_time_of_completion_today)
    @metrics.merge!(number_of_tasks_completed_this_week: tasks_completed_this_week.count)
    @metrics.merge!(number_of_tasks_blocked_internally_this_week: tasks.where('blocked_internal_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week).count)
    @metrics.merge!(number_of_tasks_blocked_externally_this_week: tasks.where('blocked_external_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week).count)
    @metrics.merge!(average_time_of_completion_this_week: average_time_of_completion_this_week)
  end
end
