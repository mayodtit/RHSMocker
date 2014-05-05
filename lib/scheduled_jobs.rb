class ScheduledJobs
  def self.unset_premium_for_expired_subscriptions
    Member.where('free_trial_ends_at < ?', DateTime.now).each do |user|
      Rails.logger.info "Unsetting premium flag for user #{user.id} - free trial expired #{user.free_trial_ends_at}"
      user.is_premium = false
      user.free_trial_ends_at = nil
      user.subscription_ends_at = nil
      user.save!
    end

    Member.where('subscription_ends_at < ?', DateTime.now).each do |user|
      Rails.logger.info "Unsetting premium flag for user #{user.id} - subscription expired #{user.subscription_ends_at}"
      user.is_premium = false
      user.free_trial_ends_at = nil
      user.subscription_ends_at = nil
      user.save!
    end
  end
end
