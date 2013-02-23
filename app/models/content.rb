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

#trying to mirror the as_json call, to provide a similar look to the controller
def as_html(options)
	if options && options["layout"] == "cardview"
		html = self.asCardView
	else
		html = self.asFullArticle
	end
end

def asFullArticle
	item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""><link href=""/assets/contents.css"" rel=""stylesheet"" type=""text/css""></head><body><div class=content"">"
	
	item += "<div class=""content_title"">"+ title + "</div>"

	if !abstract.nil?
		item += "<div class=""content_title"">"+ abstract + "</div>"
	end

	# if !content_authors.first.nil?
	# 	if !content_authors.first.user.imageURL.empty?
	# 		item += "<div class=""authorPicture"" style=""float:left""><img src=""/assets/" + content_authors.first.user.imageURL + "/></div>"
	# 	end
	# 	item +="<div class=""content_subtitle""> " + created_at.to_s + "&nbsp;|&nbsp;By&nbsp;" 
	# 	+ content_authors.first.user.firstName + "&nbsp;" + content_authors.first.user.lastName + "</div>" 
	# end

	item += "<div class=""content_text"">" + body + "</div>"
	item += "</div></body></html>"
end

def asCardView
	item = "<html><head><link href=""/assets/application.css"" rel=""stylesheet"" type=""text/css""><link href=""/assets/contents.css"" rel=""stylesheet"" type=""text/css""></head><body><div class=content"">"

	item += "<div class=""content_title"">"+ title + "</div>"

	if !abstract.nil?
		item += "<div class=""content_title"">"+ abstract + "</div>"
	end

	if !body.nil?

		item += "<div class=""content_text"">" + Nokogiri::HTML.parse(body).css('p').first.text + "</div>"
		item += "<div class=""more_text""> More... </div>"
	end

	item += "</div></body></html>"
end

#Utility Methods to be removed
def self.getRandomContent
	Content.find(:first, :offset =>rand(count))
end
end


