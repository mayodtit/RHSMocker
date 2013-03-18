class Content < ActiveRecord::Base

  attr_accessible :title, :body, :contentsType, :abstract, :question, :keywords, :updateDate
  
  has_and_belongs_to_many :authors
  has_many :contents_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :contents_mayo_vocabularies

  has_many :user_readings
  has_many :users,
    :through => :user_readings,
    :select => "users.*, user_readings.completed_date AS completedDate"

  searchable do
    text :body
    text :title, :boost => 2.0
    text :keywords
  end

  def as_json(options=nil)
    if options && options["source"].present?
      json = {:title => title, :contents_type => contentsType, :contentID => id, :body => options["source"]}
    else
      json =  {:title => title, :contents_type => contentsType, :contentID => id, :body => body}
    end
  end

########
# Get the first 20 words, remove the word "Description" from the start and any opening <p> tag we 
# may not close, and then add an ellipsis to the end. This is only used in the preview cardview
########
  def previewText
    if !body.nil?

      # two_sentances = body.split('. ').slice(0, 3).join('. ').gsub(/\ADescription/, '')
      preview = body.split(' ').slice(0, 20).join(' ').gsub(/\ADefinition<p>/, "") + "&hellip;"
      #todo add in javascript link here
    end
  end

  #Utility Methods to be removed
  def self.getRandomContent
    Content.find(:first, :offset =>rand(count))
  end

end
