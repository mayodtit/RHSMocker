module TimeExtension
  extend ActiveSupport::Concern

  def pacific
    in_time_zone('Pacific Time (US & Canada)')
  end

  def nine_oclock
    Time.new(year, month, day, 9, 0, 0, strftime('%:z'))
  end

  def ten_oclock
    Time.new(year, month, day, 10, 0, 0, strftime('%:z'))
  end

  def eight_oclock
    Time.new(year, month, day, 8, 0, 0, strftime('%:z'))
  end

  def eighteen_oclock
    Time.new(year, month, day, 18, 0, 0, strftime('%:z'))
  end

  def on_call_start_oclock
    Time.new(year, month, day, ON_CALL_START_HOUR, 0, 0, strftime('%:z'))
  end

  def next_wday(wday)
    if wday > self.wday
      self + (wday - self.wday).days
    else
      self + (7 - self.wday + wday).days
    end
  end

  def business_minutes_from(minutes)
    prev_global_time_zone = Time.zone

    # Perform all calculations in Pacific timezone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
    new_time = (self + minutes.minutes).business_time? ? self + minutes.minutes : 0.business_hours.after(self + minutes.minutes)
    Time.zone = prev_global_time_zone
    new_time
  end

  def next_business_day_in_words(time_zone = nil)
    # Use our timezone if none is specified
    time_zone ||= ActiveSupport::TimeZone.new('America/Los_Angeles')

    prev_global_time_zone = Time.zone

    # Perform all calculations in Pacific timezone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')

    self_in_time_zone = self.in_time_zone Time.zone
    next_business_day = Time.roll_forward(self_in_time_zone).in_time_zone Time.zone

    hours_between = (next_business_day - self_in_time_zone) / 1.hour

    # Restore global time zone
    Time.zone = prev_global_time_zone

    if next_business_day == self_in_time_zone
      'now'
    else
      # Convert to specified time zone, so text is in that time zone
      self_in_time_zone = self_in_time_zone.in_time_zone time_zone
      next_business_day = next_business_day.in_time_zone time_zone

      if next_business_day.day() != self_in_time_zone.day()
        if hours_between > 24
          Date::DAYNAMES[next_business_day.wday()].titleize
        else
          'tomorrow'
        end
      else
        "later today"
      end
    end
  end

  def business_time?
    prev_global_time_zone = Time.zone

    # Perform all calculations in Pacific timezone
    Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')

    self_in_time_zone = self.in_time_zone Time.zone
    is_business_time = Time.workday?(self_in_time_zone) && !(Time.before_business_hours?(self_in_time_zone) || Time.after_business_hours?(self_in_time_zone))

    # Restore global time zone
    Time.zone = prev_global_time_zone

    is_business_time
  end
end

Time.send(:include, TimeExtension)
ActiveSupport::TimeWithZone.send(:include, TimeExtension)
