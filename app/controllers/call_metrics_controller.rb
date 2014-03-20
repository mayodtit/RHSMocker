class CallMetricsController < ApplicationController
  http_basic_authenticate_with name: 'iheart', password: 'soylent'

  def index
    phone_call_epoch = PhoneCall.first.created_at
    beginning_of_this_week = Time.now.beginning_of_week(:sunday)

    processing_week = phone_call_epoch.beginning_of_week(:sunday)
    @results = []

    while processing_week <= beginning_of_this_week do
      cm = NurseCallMetrics.new(processing_week, processing_week.end_of_week(:sunday)).to_json

      # calculate cumulative stats
      cm[:num_calls][:all_time] = cm[:num_calls][:new].clone
      cm[:ended_calls_per_nurse][:all_time] = cm[:ended_calls_per_nurse][:new].clone
      unless @results.empty?
        prev_totals = @results.last[:data]
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

      @results << {date: "#{processing_week.strftime('%Y-%m-%d')}".to_sym, data: cm}
      processing_week += 1.week
    end

    respond_to do |format|
      format.html {prep_views; render layout: false}
      format.json {render json: @results, root: false}
    end
  end

  private

  def prep_views
    @columns = []
    @columns << prep_row_labels

    # placeholder for organizing results for both html and csv use
    # move hash logic from index.html to prep_results method
    #@columns << prep_results(6)
  end

  def prep_row_labels
    row_labels = [
      'Week of',
      'New calls, completed',
      'New calls, claimed but not ended',
      'Total calls, completed',
      'Total calls, claimed but not ended',
      'Call length (min) - average',
      'Call length (min) - median',
      'Total Better members',
      'Calls per members that called',
      'Calls per all members',
      'Calls per nurse (# completed calls / # nurses that took calls)'
    ]

    @all_nurses = @results.last[:data][:ended_calls_per_nurse][:all_time].keys.sort
    @all_nurses.each do |nurse|
      name = User.find(nurse).full_name
      row_labels << "#{name} - calls taken, new"
      row_labels << "#{name} - calls taken, % of all new calls"
      row_labels << "#{name} - calls taken, call time"
    end
    row_labels
  end
end
