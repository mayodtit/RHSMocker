class Attachment < ActiveRecord::Base
  attr_accessible :url
  belongs_to :message
end
