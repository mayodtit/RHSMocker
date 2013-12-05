class Content < ActiveRecord::Base
  include SolrExtensionModule
  CONTENT_TYPES = %w(Article Answer HealthTip FirstAid)

  has_many :user_readings
  has_many :users, :through => :user_readings
  has_many :content_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :content_mayo_vocabularies
  has_many :messages
  has_many :contents_symptoms_factors
  has_many :symptoms_factors, :through => :contents_symptoms_factors
  has_and_belongs_to_many :symptoms
  has_many :content_references, foreign_key: :referrer_id
  has_many :referees, through: :content_references

  attr_accessible :title, :raw_body, :content_type, :abstract, :question, :keywords,
                  :content_updated_at, :document_id, :show_call_option,
                  :show_checker_option, :show_mayo_copyright, :type, :raw_preview,
                  :state_event

  validates :title, :raw_body, :content_type, :document_id, presence: true
  validates :show_call_option, :show_checker_option, :show_mayo_copyright, inclusion: {:in => [true, false]}
  validates :document_id, uniqueness: true

  before_validation :set_defaults, on: :create

  searchable do
    text :raw_body
    text :title, :boost => 2.0
    text :keywords
    string :type
    string :state
  end

  def self.unpublished
    where(:state => :unpublished)
  end

  def self.published
    where(:state => :published)
  end

  def self.install_message
    where(:title => 'Welcome to Better!').first
  end

  # TODO - replace in future with root_share_url, move append to UserReading
  def share_url(user_reading_id=nil)
    result = "/contents/#{document_id}"
    result+= "/#{user_reading_id}" if user_reading_id
    result
  end

  def root_share_url
    document_id.present? ? "/contents/#{document_id}" : nil
  end

  def self.random
    published.where(:content_type => CONTENT_TYPES)
             .where('document_id != ?', MayoContent::TERMS_OF_SERVICE)
             .first(order: rand_str)
  end

  def content_type_display
    if content_type == 'TestProcedure'
      'Test/Procedure'
    else
      content_type.underscore.humanize.titleize
    end
  end

  def self.next_for(user)
    random
  end

  def active_model_serializer
    ContentSerializer
  end

  state_machine :initial => :unpublished do
    event :publish do
      transition all - :published => :published
    end

    event :unpublish do
      transition all - :unpublished => :unpublished
    end

    after_transition any => any do |content, transition|
      Sunspot.index content
      Sunspot.commit
    end
  end

  protected

  # RANDOM() is PSQL specific
  # TODO: remove this once we migrate over to MySQL
  def self.rand_str
    @rand_str ||= (Rails.configuration.database_configuration[Rails.env]['adapter'] == 'postgresql') ? 'RANDOM()' : 'RAND()'
  end

  def set_defaults
    self.show_call_option = true if show_call_option.nil?
    self.show_checker_option = true if show_checker_option.nil?
    self.show_mayo_copyright = false if show_mayo_copyright.nil?
  end
end
