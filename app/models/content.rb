class Content < ActiveRecord::Base
  include SolrExtensionModule

  has_many :user_readings
  has_many :users, :through => :user_readings
  has_many :content_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :content_mayo_vocabularies
  has_many :messages
  has_many :contents_symptoms_factors
  has_many :symptoms_factors, :through => :contents_symptoms_factors
  has_and_belongs_to_many :symptoms

  attr_accessible :title, :body, :content_type, :abstract, :question, :keywords,
                  :content_updated_at, :mayo_doc_id, :show_call_option,
                  :show_checker_option

  searchable do
    text :body
    text :title, :boost => 2.0
    text :keywords
  end

  def self.install_message
    where(:title => 'Welcome to Better!').first
  end

  # TODO - replace in future with root_share_url, move append to UserReading
  def share_url user_reading_id=nil
    result = "/contents/#{mayo_doc_id}"
    result+= "/#{user_reading_id}" if user_reading_id
    result
  end

  def root_share_url
    mayo_doc_id.present? ? "/contents/#{mayo_doc_id}" : nil
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

  # Utility Methods to be removed
  def self.getRandomContent
    types = ["Article", "Answer", "Health Tip", "First Aid"]
    Content.where(:content_type => types).first(:order => "RANDOM()")
  end

  CSV_COLUMNS = %w(id mayo_doc_id content_type title)

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      all.each do |content|
        csv << content.attributes.values_at(*CSV_COLUMNS)
      end
    end
  end
end
