class Feedback < ActiveRecord::Base
  belongs_to :user
  attr_accessible :note, :user
end
