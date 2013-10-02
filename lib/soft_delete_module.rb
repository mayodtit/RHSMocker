module SoftDeleteModule
  def self.included(base)
    base.class_eval do
      default_scope { where(disabled_at: nil) }
    end
  end

  def destroy
    run_callbacks :destroy do
      update_attribute(:disabled_at, Time.now)
      self
    end
  end

  alias_method :destroy!, :destroy
end
