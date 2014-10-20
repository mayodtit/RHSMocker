class ScheduledCommunicationObserver < ActiveRecord::Observer
  def after_commit(scheduled)
    create_delivery_job(scheduled)
  end

  private

  def create_delivery_job(scheduled)
    return unless scheduled.previous_changes[:publish_at]
    begin
      scheduled.create_delivery_job
    rescue ActiveRecord::StatementInvalid
      Rails.logger.error("Failed to create DeliverScheduledCommunicationJob for ScheduledCommunication with id=#{scheduled.id}")
    end
  end
end
