class TimeOffset < ActiveRecord::Base
  attr_accessible :direction, :offset_type, :fixed_time, :num_days, :relative_time

  validates :direction, :offset_type, presence: true
  validates :direction, inclusion: { in: [:before, :after], message: "Direction must be either 'before' or 'after'" }
  validates :offset_type, inclusion: { in: [:fixed, :relative], message: "Offset_type must be either 'fixed' or 'relative'"}
  validate :fixed_offsets_require_fixed_time_and_num_days
  validate :relative_offsets_require_relative_time

  def calculate(base_time_with_zone)
    # stub
  end

  private

  def fixed_offsets_require_fixed_time_and_num_days
    return unless offset_type == :fixed
    unless (fixed_time.present? && num_days.present?)
      if fixed_time.nil?
        errors.add(:fixed_time, "must be provided when offset_type == :fixed")
      end
      if num_days.nil?
        errors.add(:num_days, "must be provided when offset_type == :fixed")
      end
    end
  end

  def relative_offsets_require_relative_time
    return unless offset_type == :relative
    if relative_time.nil?
      errors.add(:relative_time, "must be provided when offset_type == :relative")
    end
  end
end
