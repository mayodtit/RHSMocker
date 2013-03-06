class Message < ActiveRecord::Base
  attr_accessible :text
  has_and_belongs_to_many :mayo_vocabulary
  belongs_to :user
  has_many :attachments
end
