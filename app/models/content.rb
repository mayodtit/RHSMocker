class Content < ActiveRecord::Base
  	attr_accessible :headline, :text, :author, :contentsType
  	
  	belongs_to :author
  	
  	has_many :user_readings

  	has_many :users, 
  				:through => :user_readings, 
  				:select => "users.*, user_readings.completed_date AS completedDate"

  def from
  	attributedHeadine = author.shortName + " has a message for you about " + headline
  end

  def article
  	item = "<html><head></head><body>"

  	if !author.nil?
  		if !author.imageURL.empty?
  			item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
  		end
  		item +="<div class=""content_subtitle"">From " + author.name + "</div>" 
  	end

  	item += "<div class=""content_text"">" + text + "</div>"
  	item += "</body></html>"

  end

end
