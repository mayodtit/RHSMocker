class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content

  belongs_to :content
  belongs_to :user

  def as_json(options)
  	{:content_id => content.id, :content_headline => content.headline, :user_id => user_id, :read_date => read_date, :read_later_date => read_later_date, :dismiss_date => dismiss_date}
  end

end
