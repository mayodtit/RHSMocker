class CallMetrics
  def initialize(start_time, end_time)
    @completed_calls = PhoneCall.where(ended_at: start_time..end_time)
    @dropped_calls = PhoneCall.where(state: 'disconnected').where(updated_at: start_time..end_time)
  end

  def num_completed_calls
    @completed_calls.count
  end

  def median_call_length
    call_lengths = @completed_calls.map {|c| c.ended_at - c.claimed_at}
    call_lengths.sort!

    len = call_lengths.length
    if len == 0
      0.0
    else
      median = (call_lengths[(len - 1) / 2] + call_lengths[len / 2]) / 2.0
      median / 60
    end
  end

  def calls_per_member
    cm_hash = @completed_calls.group(:user_id).count
    cm_hash.length == 0 ? 0 : cm_hash.values.sum / cm_hash.length.to_f
  end

  def calls_per_nurse
    cm_hash = @completed_calls.group(:ender_id).count
    cm_hash.length == 0 ? 0 : cm_hash.values.sum / cm_hash.length.to_f
  end

  def num_dropped_calls
    @dropped_calls.count
  end
end