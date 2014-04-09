class ScheduledJobs
  def self.unset_premium_for_expired_subscriptions
    User.where('subscription_end_date < ?', DateTime.now).each do |user|
      Rails.logger.info "Unsetting premium flag for user #{user.id} - subscription expired #{user.subscription_end_date}"
      user.is_premium = false
      user.subscription_end_date = nil
      user.save!
    end
  end
end
