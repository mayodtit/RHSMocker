class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :read_later_count, :read_later_date, :user, :content, :user_id, :content_id, :view_date

  belongs_to :content
  belongs_to :user

  scope :unread,  :conditions => { :read_date => nil, :dismiss_date => nil, :read_later_count=>0, :view_date => nil } 
  scope :read, :conditions =>  "(read_date is not null) or (dismiss_date is not null) or read_later_count>0"
  scope :not_dismissed, :conditions => {:dismiss_date => nil} 
  scope :for_timeline, :conditions => {:view_date => nil}

  def as_json options=nil
    {
      id:id,
      read_date:read_date, 
      dismiss_date:dismiss_date, 
      read_later_date:read_later_date, 
      title:content.title,
      contentsType:content.contentsType,
      content_id:content.id,
      mayo_doc_id:content.mayo_doc_id,
      created_at:created_at,
      share_url:content.share_url(id)
    }

  end
end
