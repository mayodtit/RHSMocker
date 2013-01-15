class UserReading < ActiveRecord::Base
  attr_accessible :completed_date, :user, :content

  belongs_to :content
  belongs_to :user

end
