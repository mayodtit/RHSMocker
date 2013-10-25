class Content < ActiveRecord::Base
  include SolrExtensionModule

  CONTENT_TYPES = %w(Article Answer HealthTip FirstAid)
  CSV_COLUMNS = %w(id mayo_doc_id content_type title)

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
                  :show_checker_option, :show_mayo_copyright

  validates :title, :body, :content_type, :mayo_doc_id, presence: true
  validates :show_call_option, :show_checker_option, :show_mayo_copyright, inclusion: {:in => [true, false]}
  validates :mayo_doc_id, uniqueness: true

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

  # RANDOM() is PSQL specific
  def self.random
    where(:content_type => CONTENT_TYPES).first(:order => "RANDOM()")
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      all.each do |content|
        csv << content.attributes.values_at(*CSV_COLUMNS)
      end
    end
  end

  def content_type_display
    if content_type == 'Disease'
      'Condition'
    else
      content_type.underscore.humanize.titleize
    end
  end

  def self.mayo_terms_of_service
    @mayo_terms_of_service ||= find_by_mayo_doc_id('AM00021')
  end

  def self.next_for(user)
    random
  end
end
