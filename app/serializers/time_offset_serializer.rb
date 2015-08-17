class TimeOffsetSerializer < ActiveModel::Serializer
  self.root = false

  attributes :direction, :offset_type, :absolute_minutes, :relative_days, :relative_minutes_after_midnight
end
