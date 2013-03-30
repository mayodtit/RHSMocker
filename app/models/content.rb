class Content < ActiveRecord::Base

	attr_accessible :title, :body, :contentsType, :abstract, :question, :keywords, :updateDate

	has_and_belongs_to_many :authors
	has_many :contents_mayo_vocabularies
	has_many :mayo_vocabularies, :through => :contents_mayo_vocabularies

	has_many :user_readings
	has_many :users,
		:through => :user_readings,
		:select => "users.*, user_readings.completed_date AS completedDate"

  	has_many :messages

	searchable do
		text :body
		text :title, :boost => 2.0
		text :keywords
	end

	def as_json(options=nil)
    if options && options["source"].present?
      json_body = options["source"]
    else
      json_body = body
    end
    {:title => title, :contents_type => contentsType, :contentID => id, :body=>json_body}
	end

########
# Get the first 20 words, remove the word "Description" from the start and any opening <p> tag we
# may not close, and then add an ellipsis to the end. This is only used in the preview cardview
########
def previewText
  if !body.nil?
      preview = body.split(' ').slice(0, 21).join(' ').gsub(/\ADefinition<p>/, "") 
      preview +=  "&hellip;"
  end
end

########
# Insert the "would you like to call someone text"
########
def reformattedBody
	if !body.nil? 
		case 
		when body.scan('</p>').count > 1
          body.insert(body.index(/<\/p>/,body.index(/<\/p>/)+4)+4, talkDiv)
        when body.scan('</p>').count == 1
          body.insert(body.index(/<\/p>/)+4, talkDiv)
		else
		  body.insert(body.index(/<\/body>/)+6, talkDiv)
		end
  	end
  	body
end

########
# THIS IS NOT HOW I PLAN ON DOING IT - TESTING OUT THE IDEA FIRST
# VIEW CODE IN THE MODEL == BAD
########
 def talkDiv
	insertHTML = '<div class="talk" ' 
	insertHTML += javascriptOpening 
	insertHTML += '><div class="talk_icon"></div><div class="talk_content">Would you like to discuss this with a healthcare professional?</div></div>'
 end

 def javascriptOpening

  openingJavascript = 'onclick="document.actionJSON = \''

  openingJavascript += '[{'

  openingJavascript += '&quot;type&quot;:&quot;launch_call_screen&quot;,'
  openingJavascript += '&quot;body&quot;:{'
  openingJavascript += '&quot;content_id&quot; : ' + '&quot;' + id.to_s+ '&quot;,' 
  openingJavascript += '&quot;keywords&quot;: ['

  contents_mayo_vocabularies[0..6].each do |vocab|
  	if !vocab.nil?
  		openingJavascript += '&quot;' + vocab.mayo_vocabulary.title + '&quot;,'
  	end
  end

  openingJavascript += '],'
  #openingJavascript += '&quot;selected_keywords&quot;: [&quot;diabetes&quot;, &quot;treatment&quot;],'
  openingJavascript += '&quot;message_body&quot; : &quot;I was reading the article ' + self.title + ' and would like to discuss it with a Health Advocate. &quot;'

  openingJavascript += '}'
  openingJavascript += '}]\';'

  openingJavascript += ' window.location.href = &quot;http://dontload/&quot;"'

  openingJavascript
 end

 #Utility Methods to be removed
  def self.getRandomContent
  	types = ["Article", "Answer", "Health Tip"]
    if Rails.env.development? || Rails.env.test?
      content = Content.first(:order => "RANDOM()", :conditions => ["contentsType IN (?)", types])
    else
      content = Content.first(:order => "RAND()", :conditions => ["contentsType IN (?)", types])
    end
    content
  end

end
