class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :save_count, :save_date, :user, :content, :user_id, :content_id, :view_date

  belongs_to :content
  belongs_to :user

  scope :unread,  :conditions => { :read_date => nil, :dismiss_date => nil, :save_date=>nil, :view_date => nil } 
  scope :saved, :conditions => "(save_date is not null) and (dismiss_date is null)"
  scope :not_dismissed, :conditions => {:dismiss_date => nil} 
  scope :for_timeline, :conditions => {:view_date => nil}

  def as_json options=nil
    {
      read_date:read_date, 
      dismiss_date:dismiss_date, 
      save_date:save_date, 
      title:content.title,
      contentsType:content.contentsType,
      content_id:content.id,
      created_at:created_at,
      share_url:content.share_url(id)
    }
  end

  def merge user_reading
    [:read_date, :dismiss_date, :save_date, :view_date].each do |field|
      old_value = send(field)
      new_value = user_reading.send(field)
      if new_value
        if old_value
          if old_value < new_value
            update_attribute field, new_value
          end
        else
          update_attribute field, new_value
        end
      end
    end
    update_attribute :save_count, save_count+user_reading.save_count
  end

end
