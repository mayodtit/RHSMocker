class TimeOffset < ActiveRecord::Base
  attr_accessible :direction, :offset_type, :fixed_time, :num_days, :relative_time

  VALID_OFFSET_TYPES = [:fixed, :relative]
  VALID_DIRECTIONS = [:before, :after]

  belongs_to :system_relative_event_template, inverse_of: :time_offset
  symbolize :offset_type, in: VALID_OFFSET_TYPES
  symbolize :direction, in: VALID_DIRECTIONS

  validates :direction, :offset_type, presence: true
  validates :direction, inclusion: { in: VALID_DIRECTIONS, message: "Direction must be either 'before' or 'after'" }
  validates :offset_type, inclusion: { in: VALID_OFFSET_TYPES, message: "Offset_type must be either 'fixed' or 'relative'"}
  validate :fixed_offsets_require_fixed_time
  validate :relative_offsets_require_relative_time_and_num_days

  before_validation :set_defaults, on: :create

  def calculate(base_time_with_zone)
    raise "Invalid offset_type #{offset_type} - cannot calculate" unless VALID_OFFSET_TYPES.include?(offset_type)
    self.send("calculate_#{offset_type}".to_sym, base_time_with_zone)
  end

  private

  def set_defaults
    self.offset_type ||= :fixed
    self.direction ||= :before
    self.fixed_time ||= Time.at(0)
    self.num_days ||= 0
    self.relative_time ||= Time.at(0)
  end

  def calculate_fixed(base_time_with_zone)
    raise "Missing fixed_time - cannot calculate" unless fixed_time.present?
    base_time_with_zone.send(date_shift_fn, fixed_time.to_i.seconds)
  end

  def calculate_relative(base_time_with_zone)
    raise "Missing relative_time - cannot calculate" unless relative_time.present?
    raise "Missing num_days - cannot calculate" unless num_days.present?
    start_date = base_time_with_zone.beginning_of_day
    new_date = start_date.send(date_shift_fn, num_days.days)
    new_time = relative_time.seconds_since_midnight.seconds
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

  def fixed_offsets_require_fixed_time
    return unless offset_type == :fixed
    if fixed_time.nil?
      errors.add(:fixed_time, "must be provided when offset_type == :fixed")
    end
  end

  def relative_offsets_require_relative_time_and_num_days
    return unless offset_type == :relative
    unless (relative_time.present? && num_days.present?)
      if relative_time.nil?
        errors.add(:relative_time, "must be provided when offset_type == :relative")
      end
      if num_days.nil?
        errors.add(:num_days, "must be provided when offset_type == :fixed")
      end
    end
  end
end
