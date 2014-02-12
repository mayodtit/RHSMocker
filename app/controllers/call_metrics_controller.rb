class CallMetricsController < ApplicationController
  http_basic_authenticate_with name: 'iheart', password: 'soylent'

  def index
    phone_call_epoch = PhoneCall.first.created_at
    beginning_of_this_week = Time.now.beginning_of_week(:sunday)

    processing_week = phone_call_epoch.beginning_of_week(:sunday)
    @results = []

    while processing_week <= beginning_of_this_week do
      cm = NurseCallMetrics.new(processing_week, processing_week.end_of_week(:sunday))
      @results << [processing_week.strftime('%Y-%m-%d'), cm]
      processing_week += 1.week
    end

    # get list of all nurses who have taken a nurseline call longer than a minute
    unique_claimer_ids = PhoneCall.valid_nurse_call.pluck(:claimer_id).uniq
    @nurses = User.find(unique_claimer_ids)
    @nurse_totals = Hash.new(0)
  end
end