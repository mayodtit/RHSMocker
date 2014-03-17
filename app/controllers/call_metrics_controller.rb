class CallMetricsController < ApplicationController
  http_basic_authenticate_with name: 'iheart', password: 'soylent'

  def index
    phone_call_epoch = PhoneCall.first.created_at
    beginning_of_this_week = Time.now.beginning_of_week(:sunday)

    processing_week = phone_call_epoch.beginning_of_week(:sunday)
    @results = {}

    while processing_week <= beginning_of_this_week do
      cm = NurseCallMetrics.new(processing_week, processing_week.end_of_week(:sunday)).to_json

      # calculate cumulative stats
      cm[:num_calls][:all_time] = cm[:num_calls][:new].clone
      cm[:ended_calls_per_nurse][:all_time] = cm[:ended_calls_per_nurse][:new].clone
      unless @results.empty?
        cm[:ended_calls_per_nurse][:all_time].default = 0
        prev_totals = @results.values.last
        calls_all_time = prev_totals[:num_calls][:all_time]
        calls_all_time.each do |k,v|
          cm[:num_calls][:all_time][k] += v
        end

        nurse_all_time = prev_totals[:ended_calls_per_nurse][:all_time]
        nurse_all_time.each do |k,v|

          # since we have the default hash value set above, we don't have to worry about checking for non-existent keys
          cm[:ended_calls_per_nurse][:all_time][k] += v
        end
      end

      @results.merge!({"#{processing_week.strftime('%Y-%m-%d')}".to_sym => cm})
      processing_week += 1.week
    end

    render json: @results, root: false
  end
end