class PhaCapacityMetricsService
  def call
    Member.premium_states.group(:pha).count.map do |k, v|
      {
        label: k.full_name,
        value: v
      }
    end
  end
end
