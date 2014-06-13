module TimeExtension
  extend ActiveSupport::Concern

  def pacific
    in_time_zone('Pacific Time (US & Canada)')
  end

  def next_wday(wday)
    if wday > self.wday
      self + (wday - self.wday).days
    else
      self + (7 - self.wday + wday).days
    end
  end
end

Time.send(:include, TimeExtension)
ActiveSupport::TimeWithZone.send(:include, TimeExtension)
