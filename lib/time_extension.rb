module TimeExtension
  extend ActiveSupport::Concern

  def pacific
    in_time_zone('Pacific Time (US & Canada)')
  end
end

Time.send(:include, TimeExtension)
ActiveSupport::TimeWithZone.send(:include, TimeExtension)
