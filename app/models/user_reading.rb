class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content

  belongs_to :content
  belongs_to :user

  scope :unread,  :conditions => { :read_date => nil, :dismiss_date => nil, :read_later_count=>0 } 
  scope :read, :conditions =>  "(read_date is not null) or (dismiss_date is not null) or read_later_count>0" 

  def as_json options=nil
    {
      :read_date=> read_date, 
      :dismiss_date => dismiss_date, 
      :read_later_date=> read_later_date, 
      :title=> content.title,
      :contentsType => content.contentsType,
      :content_id => content.id,
      :created_at => created_at
    }

  end
end
