module TimeoutModule
  def self.included(base)
    base.class_eval do
      default_scope { where('disabled_at IS NULL OR disabled_at > ?', Time.now) }
    end
  end

  def destroy
    run_callbacks :destroy do
      update_attribute(:disabled_at, Time.now)
      self
    end
  end

  def keep_alive(expires_at=15.minutes.from_now)
    if FeatureFlag.find_by_mkey('idle_timeout').try(:enabled?)
      update_attribute(:disabled_at, expires_at)
    end
  end

  alias_method :destroy!, :destroy
end
