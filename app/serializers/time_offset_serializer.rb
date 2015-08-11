class TimeOffsetSerializer < ActiveRecord::Base
  self.root = false

  attributes :direction, :offset_type, :fixed_time, :num_days, :relative_time
end
