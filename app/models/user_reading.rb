class UserReading < ActiveRecord::Base
  attr_accessible :read_date, :dismiss_date, :save_count, :save_date, :user, :content, :user_id, :content_id, :view_date, :priority

  belongs_to :content
  belongs_to :user

  scope :unread,  :conditions => { :read_date => nil, :dismiss_date => nil, :save_date=>nil, :view_date => nil } 
  scope :saved, :conditions => "(save_date is not null) and (dismiss_date is null)"
  scope :not_dismissed, :conditions => {:dismiss_date => nil} 
  scope :for_timeline, :conditions => {:view_date => nil}
  scope :not_saved_not_dismissed, :conditions => {:save_date => nil, :dismiss_date => nil}

  validates :user, :content, presence: true
  validates :content_id, :uniqueness => {:scope => :user_id}

  def as_json options=nil
    {
      read_date:read_date, 
      dismiss_date:dismiss_date, 
      save_date:save_date, 
      title:content.title,
      content_type:content.content_type,
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
    update_attribute :save_count, save_count.to_i+user_reading.save_count.to_i
    update_attribute :share_counter, share_counter.to_i+user_reading.share_counter.to_i
  end

end
