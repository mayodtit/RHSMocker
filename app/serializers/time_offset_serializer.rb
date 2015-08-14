class TimeOffsetSerializer < ActiveModel::Serializer
  self.root = false

  attributes :direction, :offset_type, :fixed_time, :num_days, :relative_time, :fixed_time_as_integer, :relative_time_as_integer

  delegate :fixed_time, :relative_time, to: :object

  def fixed_time_as_integer
    fixed_time.to_i
  end

  def relative_time_as_integer
    relative_time.to_i
  end
end
