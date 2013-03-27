class PhoneCall < ActiveRecord::Base
  belongs_to :message
  attr_accessible :start_time, :status, :summary, :time_to_call, :time_zone, :message_id, :counter

  validates :time_to_call, :inclusion => { :in => %w(morning afternoon evening),
    :message => "%{value} is not a call time" }

end
