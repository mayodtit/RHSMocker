class Content < ActiveRecord::Base

	#require 'lorem-ipsum'
	attr_accessible :title, :body, :contentsType, :abstract, :question, :keywords, :updateDate
	has_and_belongs_to_many :authors
	has_and_belongs_to_many :mayo_vocabularies


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
		if options["source"].present?
			json = {:title => title, :contents_type => contentsType, :contentID => id, :body => options["source"]}
		else
			json =  {:title => title, :contents_type => contentsType, :contentID => id, :body => body}
		end
	end

def previewText
	if !body.nil?
		#first_paragraph = Nokogiri::HTML.parse(body).css('p').first.text 
		two_sentances = body.split('. ').slice(0, 3).join('. ')
  		# Take first 50 words of the above
  		preview = two_sentances.split(' ').slice(0, 20).join(' ')
  		preview += "..."
  		#todo add in javascript link here
  	end
end


	def previewText
		if !body.nil?
			#first_paragraph = Nokogiri::HTML.parse(body).css('p').first.text 
			two_sentances = body.split('. ').slice(0, 3).join('. ')
	  		# Take first 50 words of the above
	  		preview = two_sentances.split(' ').slice(0, 20).join(' ')
	  		preview += "..."
	  		#todo add in javascript link here
	  	end
	end

	#Utility Methods to be removed
	def self.getRandomContent
		Content.find(:first, :offset =>rand(count))
	end

end
