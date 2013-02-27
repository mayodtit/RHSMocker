class Content < ActiveRecord::Base
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
	text :keywords
end

def as_json(options)
	json = {:title => title, :contents_type => contentsType, :contentID => id, :body => options["source"]}
end

def previewText
		#first_paragraph = Nokogiri::HTML.parse(body).css('p').first.text 
		two_sentances = body.split('. ').slice(0, 3).join('. ')
  		# Take first 50 words of the above
  		preview = two_sentances.split(' ').slice(0, 20).join(' ')
  		preview += "..."
  		#todo add in javascript link here
end

#Utility Methods to be removed
def self.getRandomContent
	Content.find(:first, :offset =>rand(count))
end
end


