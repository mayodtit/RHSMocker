class ContentAuthor < ActiveRecord::Base
  attr_accessible :user, :content

  belongs_to :content
  belongs_to :user
  
end
