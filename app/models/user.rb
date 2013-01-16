class User < ActiveRecord::Base
  attr_accessible :birthDate, :firstName, :gender, :lastName

  has_many :user_readings

  has_many :contents, 
  			:through => :user_readings

def readContent
	readingList = UserReading.find_by_sql("SELECT DISTINCT contents.*, user_readings.completed_date AS completedDate from contents INNER JOIN user_readings ON content_id = user_readings.content_id WHERE content_id = user_readings.content_id AND user_readings.user_id = " + self.id.to_s)
	readingList.uniq!
	
	readingList.each do | readingItem |
		puts readingItem
		puts readingItem.headline + readingItem.completedDate

		 if !readingItem.completedDate.nil?
		 	readingItem.completedDate = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(readingItem.completedDate))
		 end

		if !readingItem.text.nil?

		item = "<html><head></head><body>"

  		if !readingItem.author_id.nil?
  			author = Author.find(readingItem.author_id)
  			if !author.imageURL.empty?
  				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
  			end
  			item +="<div class=""articleAuthor"">From " + author.name + "</div>" 
  		end

  		item += "<div class=""articleBody"" style=""font-family:""Arial"", Arial, sans-serif;"">" + readingItem.text + "</div>"
  		item += "</body></html>"

  		readingItem.text = item

  		end
	end
	
	readingList
end

end
