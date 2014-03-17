class NurseCallMetrics
  def initialize(start_time, end_time)
    @end_time = end_time
    @all_calls = PhoneCall.where(created_at: start_time..end_time)
    @completed_calls = PhoneCall.valid_nurse_call.where(claimed_at: start_time..end_time) # calls claimed within this time frame
    @calls_claimed_but_not_ended = PhoneCall.to_nurse_line.where(claimed_at: start_time..end_time).where('claimed_at IS NOT NULL').where('ended_at IS NULL')
  end

  def average_call_length
    len = completed_call_lengths.length
    if len == 0
      0.0
    else
      completed_call_lengths.inject(:+) / len / 60.0
    end
  end

  def median_call_length
    call_lengths = completed_call_lengths
    call_lengths.sort!

    len = call_lengths.length
    if len == 0
      0.0
    else
      median = (call_lengths[(len - 1) / 2] + call_lengths[len / 2]) / 2.0
      median / 60
    end
  end

  def total_member_count
    @tmc ||= Member.where(created_at: DateTime.parse('1970-01-01')..@end_time).count
  end

  def calls_per_member
    cm_hash = @completed_calls.group(:user_id).count
    only_callers = (cm_hash.length == 0 ? 0.0 : cm_hash.values.sum / cm_hash.length.to_f)
    all = @completed_calls.length / total_member_count.to_f
    {all_members: all, only_callers: only_callers}
  end

  def calls_per_nurse
    cm_hash = ended_calls_per_nurse
    cm_hash.length == 0 ? 0 : cm_hash.values.sum / cm_hash.length.to_f
  end

  def ended_calls_per_nurse
    @ecpn ||= Hash.new(0).merge(@completed_calls.group(:claimer_id).count)
  end

  def ended_calls_per_nurse_pct
    a = Hash.new(0)
    ended_calls_per_nurse.each do |k,v|
      a[k] = 100 * v / @completed_calls.length.to_f
    end
    a
  end

  def to_json
    {
      num_calls: {
        new: {
          total: @all_calls.count,
          claimed_but_not_ended: @calls_claimed_but_not_ended.count,
          completed: @completed_calls.count
        },
      },
      call_length: {
        average: average_call_length,
        median: median_call_length
      },
      total_member_count: total_member_count,
      calls_per_member: calls_per_member,
      calls_per_nurse: calls_per_nurse,
      ended_calls_per_nurse: {
        new: ended_calls_per_nurse,
        new_pct: ended_calls_per_nurse_pct,
        all_time: {}
      }
    }
  end

  private

  def completed_call_lengths
    @ccl ||= @completed_calls.map {|c| c.ended_at - c.claimed_at}
  end
end
