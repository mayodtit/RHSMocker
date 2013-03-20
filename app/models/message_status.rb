class MessageStatus < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
  attr_accessible :status, :user_id, :message
end
