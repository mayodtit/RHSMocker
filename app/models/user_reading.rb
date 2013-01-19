class UserReading < ActiveRecord::Base
  attr_accessible :completed_date, :user, :content

  belongs_to :content
  belongs_to :user

  def as_json(options)
  		{:content => content, :user => user, :completed_date => completed_date}
  end

end
