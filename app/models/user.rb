	class User < ActiveRecord::Base
	  attr_accessible :birthDate, :firstName, :gender, :lastName

	  has_many :user_readings

	  has_many :contents, :through => :user_readings

	def readContent
		readingList = Array.new
		self.user_readings.includes(:content).each do |reading|

			reading.content

			if !reading.content.text.nil?

				item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

		  		if !reading.content.author_id.nil?
		  			author = Author.find(reading.content.author_id)
		  			if !author.imageURL.empty?
		  				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
		  			end
		  			item +="<div class=""content_subtitle""> " + reading.content.created_at.to_s + "&nbsp;|&nbsp;By " + author.name + "</div>" 
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
