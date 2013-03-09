class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content

  belongs_to :content
  belongs_to :user

  def as_json options=nil
    {:id => id,
     :content=> content}
    # :content_title => content.title,
    # :type => content.contentsType,
    # :user_id => user_id,
    # :read_date => read_date,
    # :read_later_date => read_later_date,
    # :dismiss_date => dismiss_date

  end
end
