class PhaMetricsService
  def raw_utilization
    Member.premium_states.group(:pha).count.map do |k, v|
      {
        label: k.full_name,
        value: v
      }
    end
  end

  def engaged_utilization
    Member.premium_states.with_request_or_service_task.group(:pha).count.map do |k, v|
      {
        label: k.full_name,
        value: v
      }
    end
  end
end
