class Content < ActiveRecord::Base
	attr_accessible :headline, :body, :author, :contentsType

	has_many :content_authors
	has_many :users, :through => :content_authors

	has_many :user_readings
	has_many :users, 
			:through => :user_readings, 
			:select => "users.*, user_readings.completed_date AS completedDate"

	def formatArticle
		item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

		if !content_authors.first.nil?
			if !content_authors.first.user.imageURL.empty?
				item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + content_authors.first.user.imageURL + "/></div>"
			end
			item +="<div class=""content_subtitle""> " + created_at.to_s + "&nbsp;|&nbsp;By&nbsp;" + content_authors.first.user.firstName + "&nbsp;" + content_authors.first.user.lastName + "</div>" 
		end

		item += "<div class=""content_text"">" + body + "</div>"
		item += "</body></html>"
	end

end
