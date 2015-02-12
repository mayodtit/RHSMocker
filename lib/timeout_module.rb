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
    update_attribute(:disabled_at, expires_at)
  end


  alias_method :destroy!, :destroy
end
