class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content

  belongs_to :content
  belongs_to :user

  def as_json(options)
  		{:content => content, :user => user, :read_date => read_date}
  end

end
