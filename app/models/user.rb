class User < ActiveRecord::Base
  attr_accessible :birthDate, :firstName, :gender, :lastName

  has_many :user_readings

  has_many :contents, 
  			:through => :user_readings

def readContent
	contentList = User.find_by_sql("SELECT DISTINCT contents.*, user_readings.completed_date AS completedDate from contents INNER JOIN user_readings ON content_id = user_readings.content_id WHERE content_id = user_readings.content_id AND user_readings.user_id = " + self.id.to_s)
	contentList.uniq!
	
	contentList.each do | content |

		puts content.headline + content.completedDate

		if !content.completedDate.nil?
			content.completedDate = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(content.completedDate))
		end

		if !content.text.nil?

		item = "<html><head></head><body>"

  		if !content.author_id.nil?
  			author = Author.find(content.author_id)
  			if !author.imageURL.empty?
  				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
  			end
  			item +="<div class=""articleAuthor"">From " + author.name + "</div>" 
  		end

  		item += "<div class=""articleBody"" style=""font-family:""Arial"", Arial, sans-serif;"">" + content.text + "</div>"
  		item += "</body></html>"

  		content.text = item

  		end
	end
	
	contentList
end

end
