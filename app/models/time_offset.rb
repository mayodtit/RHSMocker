class TimeOffset < ActiveRecord::Base
  MINUTES_PER_DAY = 60 * 24
  VALID_OFFSET_TYPES = [:fixed, :relative]
  VALID_DIRECTIONS = [:before, :after]

  belongs_to :system_relative_event_template, inverse_of: :time_offset
  symbolize :offset_type, in: VALID_OFFSET_TYPES
  symbolize :direction, in: VALID_DIRECTIONS

  attr_accessible :direction, :offset_type, :absolute_minutes, :relative_days, :relative_minutes_after_midnight

  validates :direction, presence: true, inclusion: { in: VALID_DIRECTIONS, message: "Direction must be either 'before' or 'after'" }
  validates :offset_type, presence: true, inclusion: { in: VALID_OFFSET_TYPES, message: "Offset_type must be either 'fixed' or 'relative'"}
  validate :fixed_offsets_require_absolute_minutes, if: :fixed?
  validate :relative_offsets_require_relative_days_and_relative_minutes_after_midnight, if: :relative?

  before_validation :set_defaults, on: :create
  before_validation :equalize_absolute_and_relative_offsets

  def calculate(base_time_with_zone)
    raise "Invalid offset_type #{offset_type} - cannot calculate" unless VALID_OFFSET_TYPES.include?(offset_type)
    self.send("calculate_#{offset_type}".to_sym, base_time_with_zone)
  end

  def fixed?
    offset_type == :fixed
  end

  def relative?
    offset_type == :relative
  end

  def before?
    direction == :before
  end

  def after?
    direction == :after
  end

  private

  def set_defaults
    self.offset_type ||= :fixed
    self.direction ||= :before
    self.absolute_minutes ||= 0
    self.relative_days ||= 0
    self.relative_minutes_after_midnight ||= 0
  end

  def equalize_absolute_and_relative_offsets
    if fixed?
      if before?
        self.relative_days = absolute_minutes / MINUTES_PER_DAY + 1
        self.relative_minutes_after_midnight = (MINUTES_PER_DAY - (absolute_minutes % MINUTES_PER_DAY)).abs
      else
        self.relative_days = absolute_minutes / MINUTES_PER_DAY
        self.relative_minutes_after_midnight = absolute_minutes % MINUTES_PER_DAY
      end
    else
      if relative_days == 0
        self.direction = :after
        self.absolute_minutes = relative_minutes_after_midnight
      elsif before?
        self.absolute_minutes = (relative_days - 1) * MINUTES_PER_DAY + MINUTES_PER_DAY - relative_minutes_after_midnight
      else
        self.absolute_minutes = relative_days * MINUTES_PER_DAY + relative_minutes_after_midnight
      end
    end
  end

  def calculate_fixed(base_time_with_zone)
    raise "Missing absolute minutes - cannot calculate" unless absolute_minutes
    base_time_with_zone.send(date_shift_fn, absolute_minutes.minutes)
  end

  def calculate_relative(base_time_with_zone)
    raise "Missing relative days - cannot calculate" unless relative_days
    raise "Missing relative minutes after midnight - cannot calculate" unless relative_minutes_after_midnight
    start_date = base_time_with_zone.beginning_of_day
    new_date = start_date.send(date_shift_fn, relative_days.days)
    new_time = relative_minutes_after_midnight.minutes
    new_date + new_time
  end

  def date_shift_fn
    if direction == :before
      :-
    elsif direction == :after
      :+
    else
      raise "Invalid direction #{direction} - cannot calculate"
    end
  end

  def fixed_offsets_require_absolute_minutes
    unless absolute_minutes
      errors.add(:absolute_minutes, "must be provided when offset_type == :fixed")
    end
  end

  def relative_offsets_require_relative_days_and_relative_minutes_after_midnight
    unless relative_days
      errors.add(:relative_days, "must be provided when offset_type == :relative")
    end

    unless relative_minutes_after_midnight
      errors.add(:relative_minutes_after_midnight, "must be provided when offset_type == :relative")
    end
  end
end
