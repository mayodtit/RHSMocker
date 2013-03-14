class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content

  belongs_to :content
  belongs_to :user

  def as_json options=nil
    {
      :read_date=> read_date, 
      :dismiss_date => dismiss_date, 
      :read_later_date=> read_later_date, 
      :read_later_count=> read_later_count,
      :title=> content.title,
      :contentsType => content.contentsType,
      :content_id => content.id
    }

  end
end
