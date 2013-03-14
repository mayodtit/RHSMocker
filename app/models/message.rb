class Message < ActiveRecord::Base
  attr_accessible :text

  has_many :message_statuses
  has_many :attachments
  
  has_and_belongs_to_many :mayo_vocabulary

  belongs_to :user
  belongs_to :encounter
  belongs_to :user_location
end
