class CallMetricsController < ApplicationController
  http_basic_authenticate_with name: 'iheart', password: 'soylent'

  def index
    phone_call_epoch = PhoneCall.first.created_at
    beginning_of_this_week = Time.now.beginning_of_week(:sunday)

    processing_week = phone_call_epoch.beginning_of_week(:sunday)
    @results = []

    while processing_week <= beginning_of_this_week do
      cm = CallMetrics.new(processing_week, processing_week.end_of_week(:sunday))
      @results << [processing_week.strftime('%Y-%m-%d'), cm]
      processing_week += 1.week
    end
  end
end