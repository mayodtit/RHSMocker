class Content < ActiveRecord::Base
	attr_accessible :headline, :text, :author, :contentsType

	belongs_to :author

	has_many :user_readings

	has_many :users, 
			:through => :user_readings, 
			:select => "users.*, user_readings.completed_date AS completedDate"

	def formatArticle
		item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

		if !author.nil?
			if !author.imageURL.empty?
				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + author.imageURL + "/></div>"
			end
			item +="<div class=""content_subtitle""> " + created_at.to_s + "&nbsp;|&nbsp;By " + author.name + "</div>" 
		end

		item += "<div class=""content_text"">" + text + "</div>"
		item += "</body></html>"
	end

end
