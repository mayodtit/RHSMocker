class MetricsController < ApplicationController
  before_filter :authenticate_api_user!

  def enrollments
    render json: {item: enrollment_metrics}, status: :ok
  end

  def pha_raw_utilization
    render json: {items: PhaMetricsService.new.raw_utilization}, status: :ok
  end

  def pha_engaged_utilization
    render json: {items: PhaMetricsService.new.engaged_utilization}, status: :ok
  end

  private

  def authenticate_api_user!
    @api_user = ApiUser.find_by_auth_token(params[:auth_token])
    raise CanCan::AccessDenied unless @api_user
  end

  def enrollment_metrics
    EnrollmentMetricsService.new(from: enrollment_from_time, to: enrollment_to_time).call
  end

  def enrollment_from_time
    params[:from] ? Time.parse(params[:from]) : Time.zone.now.pacific.beginning_of_day
  end

  def enrollment_to_time
    params[:to] ? Time.parse(params[:to]) : Time.zone.now.pacific.end_of_day
  end
end
