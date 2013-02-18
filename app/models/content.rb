class Content < ActiveRecord::Base
	require 'lorem-ipsum'
	attr_accessible :title, :body, :author, :contentsType, :abstract, :question, :keywords

	has_many :content_authors
	has_many :users, :through => :content_authors

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
  		{:title => content.title, :contents_type => content.contentsType}
  	end

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

#TO BE REMOVED 
#TEST ONLY
#====================
	def self.createFakeArticle
		fakeBody = LoremIpsum.generate(:type => "blog")
		fakeArticle = Content.create(title: self.titleWithNumber(["Lorum", "Mayo", "Ipsum", "Healthy","Foo","WellCheck"]), contentsType:"message", body:fakeBody)
		fakeArticle.save!
		fakeArticle.id
	end

	def self.titleWithNumber(words)
   		words[rand(words.length)]+(rand(900)+100).to_s()+" Headline"
	end

end
