class Content < ActiveRecord::Base
	#require 'lorem-ipsum'
	attr_accessible :title, :body, :author, :contentsType, :abstract, :question, :keywords, :updateDate

	has_many :content_authors
	has_many :users, :through => :content_authors

	has_many :content_vocabularies
	has_many :mayo_vocabularies, :through => :content_vocabularies


	has_many :user_readings
	has_many :users, 
	:through => :user_readings, 
	:select => "users.*, user_readings.completed_date AS completedDate"

#SOLR Support in model
#=============================
searchable do
	text :body 
	text :title, :boost => 2.0
	text :keywords, :boost => 3.0
end

def as_json(options)
	if options && options["layout"] == "cardview"
		json = {:title => title, :contents_type => contentsType, :contentID => id, :body => self.asCardView}
	else
		json = {:title => title, :contents_type => contentsType, :contentID => id, :body => self.asFullArticle}
	end
end


def asFullArticle
	item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

	if !content_authors.first.nil?
		if !content_authors.first.user.imageURL.empty?
			item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + content_authors.first.user.imageURL + "/></div>"
		end
		item +="<div class=""content_subtitle""> " + created_at.to_s + "&nbsp;|&nbsp;By&nbsp;" 
		+ content_authors.first.user.firstName + "&nbsp;" + content_authors.first.user.lastName + "</div>" 
	end

	item += "<div class=""content_text"">" + body + "</div>"
	item += "</body></html>"
end

def asCardView
	item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""></head><body>"

	item += "<div class=""content_title"">"+ title + "</div>"

	if !abstract.nil?
		item += "<div class=""content_title"">"+ title + "</div>"
	end
	item += "</body></html>"
end

#Utility Methods to be removed
def self.getRandomContent
	Content.find(:first, :offset =>rand(count))
end
end


