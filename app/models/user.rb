	class User < ActiveRecord::Base
	  attr_accessible :birthDate, :firstName, :gender, :lastName

	  has_many :user_readings

	  has_many :contents, :through => :user_readings

	def readContent
		#readingList = UserReading.find_by_sql("SELECT DISTINCT contents.*, user_readings.completed_date AS completedDate from contents INNER JOIN user_readings ON content_id =
		# user_readings.content_id WHERE content_id = user_readings.content_id AND user_readings.user_id = " + self.id.to_s)
		
		#readingList = UserReading.includes(:content, :user).where("user_id = ?", self.id)
		
		#readingList.uniq!
		

		#readingList.each do | readingItem |
		readingList = Array.new
		self.user_readings.includes(:content).each do |reading|

			reading.content

			#puts content.headline + readingItem.completed_date.to_formatted_s(:db)

			 # if !readingItem.completed_date.nil?
			 # 	readingItem.completed_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(readingItem.completed_date))
			 # end

			if !reading.content.text.nil?

				item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

		  		if !reading.content..author_id.nil?
		  			author = Author.find(reading.content.author_id)
		  			if !author.imageURL.empty?
		  				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
		  			end
		  			item +="<div class=""content_subtitle""> " + reading.content..created_at.to_s + "&nbsp;|&nbsp;By " + author.name + "</div>" 
		  		end

		  		item += "<div class=""content_text"">" + reading.content.text + "</div>"
		  		item += "</body></html>"

		  		reading.content.text = item

	  		end
	  		readingList << reading
		end
		
		readingList 
	end

	end
