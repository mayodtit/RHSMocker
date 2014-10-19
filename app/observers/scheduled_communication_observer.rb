class ScheduledCommunicationObserver < ActiveRecord::Observer
  def after_commit(scheduled)
    create_delivery_job(scheduled)
  end

  private

  def create_delivery_job(scheduled)
    return unless scheduled.previous_changes[:publish_at]
    begin
      scheduled.transaction do
        job = DeliverScheduledCommunicationJob.create(scheduled.id, scheduled.publish_at)
        scheduled.update_attribute(:delayed_job_id, job.id)
      end
    rescue ActiveRecord::StatementInvalid
      Rails.logger.error("Failed to create DeliverScheduledCommunicationJob for ScheduledCommunication with id=#{scheduled.id}")
    end
  end
end
