class Content < ActiveRecord::Base

	attr_accessible :title, :body, :content_type, :abstract, :question, :keywords, :content_updated_at, :mayo_doc_id

	has_many :content_mayo_vocabularies
	has_many :mayo_vocabularies, :through => :content_mayo_vocabularies


  has_many :authors_contents
  has_many :authors, :through=>:authors_contents

	has_many :user_readings
	has_many :users,
		:through => :user_readings,
		:select => "users.*, user_readings.completed_date AS completedDate"

  	has_many :messages
  	has_and_belongs_to_many :symptoms
    has_many :contents_symptoms_factors
  	has_many :symptoms_factors, :through => :contents_symptoms_factors

	searchable do
		text :body
		text :title, :boost => 2.0
		text :keywords
	end

  def self.install_message
    where(:title => 'Welcome to Better!').first
  end

  def self.new_member_content
    where(:title => ['Your Allergies',
                     'Your Gender',
                     'Which of these do you eat?'])
  end

	def as_json(options=nil)
    if options && options["source"].present?
      json_body = options["source"]
    else
      json_body = body
    end
    result = {:title => title, :contents_type => content_type, :contentID => id, :body=>json_body }
    if options && options[:user_reading_id].present?
      result.merge!(user_reading_id:options[:user_reading_id], :share_url=>share_url(options[:user_reading_id]))
    end
    result
	end

########
# Get the first 100 words, remove the word "Description" from the start and any opening <p> tag we
# may not close, and then add an ellipsis to the end. This is only used in the preview cardview
########
def previewText
  if !body.nil?
      preview = body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "") 
  end
end
alias_method :preview, :previewText

# TODO - replace in future with root_share_url, move append to UserReading
def share_url user_reading_id=nil
  result = "/contents/#{mayo_doc_id}"
  result+= "/#{user_reading_id}" if user_reading_id
  result
end

def root_share_url
  mayo_doc_id.present? ? "/contents/#{mayo_doc_id}" : nil
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
      when !body.index(/<\/body>/).nil?
        body.insert(body.index(/<\/body>/)+6, talkDiv)
      else
        
    end
  end
  body
end

#Note: The image with the Health Advocate Text is served up in the CSS talk class. 
 def talkDiv
    insertHTML = '<div class="talk" ' 
    insertHTML += javascriptOpening 
    insertHTML += "'></div>"
    insertHTML
 end

 def javascriptOpening

  openingJavascript = 'onclick="document.actionJSON = \''

  openingJavascript += '[{'

  openingJavascript += '&quot;type&quot;:&quot;launch_call_screen&quot;,'
  openingJavascript += '&quot;body&quot;:{'
  openingJavascript += '&quot;content_id&quot; : ' + '&quot;' + id.to_s+ '&quot;,' 
  #Removed Keywords consistant with https://www.pivotaltracker.com/story/show/55438340
  #openingJavascript += '&quot;keywords&quot;: ['

  #content_mayo_vocabularies[0..6].each do |vocab|
  #	if !vocab.nil?
  #		openingJavascript += '&quot;' + vocab.mayo_vocabulary.title + '&quot;,'
  #	end
  #end
  #openingJavascript += '],'
  #openingJavascript += '&quot;selected_keywords&quot;: [&quot;diabetes&quot;, &quot;treatment&quot;],'
  openingJavascript += '&quot;message_body&quot; : &quot;I was reading the article ' + self.title + ' and would like to discuss it with a Personal Health Assistant.&nbsp;&quot;'

  openingJavascript += '}'
  openingJavascript += '}]\';'

  openingJavascript += ' window.location.href = &quot;http://dontload/&quot;"'

  openingJavascript
 end

#Content Methods to find types by MCVIDs semantically
def self.byGender(gender)
  genderSpecificIDs = []
  unless gender.blank?
     gender = gender[0]
     if gender <=> 'F'
       genderSpecificIDs = ['1131','3899','3900']
     elsif gender <=> 'M'
       genderSpecificIDs = ['1130','3896','3897']
     end

     if !genderSpecificIDs.empty?
        return MayoVocabulary.where(:mcvid => genderSpecificIDs).inject([]){|array, vocab| array << vocab.contents.map(&:id);array}.flatten
     end
  end
  []
end

def self.mcvidsForAge(age)
      #Add Age Specific MCVIDS
      #Birth to 1 month = 1119
      #2 months to 2 years = 1120
      #3 to 5 years  = 1121
      #6 to 12 years = 1122
      #13 to 18 years = 1123
      #19 to 44 = 1125 
      #45 to 64 = 1126
      #65 to 80 = 1127
      #80 and over = 1128

      mcvid_array = []

      case age 
        when 0..2  then
          mcvid_array << '1119'
          mcvid_array << '1120'
        when 3..5 then
          mcvid_array << '1121'
        when 6..12 then
          mcvid_array << '1122'
        when 13..18 then
          mcvid_array << '1123'
        when 19..44 then
          mcvid_array << '1125'
        when 45..64 then
          mcvid_array << '1126'
        when 65..80 then
          mcvid_array << '1127'
        when 80..200 then
          mcvid_array << '1128'
      end

      mcvid_array
end



 #Utility Methods to be removed
  def self.getRandomContent
    types = ["Article", "Answer", "Health Tip", "First Aid"]
    Content.where(:content_type => types).first(:order => "RANDOM()")
  end

end
