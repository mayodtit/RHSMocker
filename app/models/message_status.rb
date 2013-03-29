class MessageStatus < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
  attr_accessible :status, :user_id, :message
  #scope :unread_for_user , lambda{|user| :conditions=>[:user=>user, status=>"unread"]}
  scope :unread_for_user, lambda { |user_id| {:conditions =>["status=? and user_id=?", "unread", user_id] } }
  scope :unread, :conditions => { :status => "unread"} 
  scope :read, :conditions => { :status => "read"} 
end
