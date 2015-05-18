class Content < ActiveRecord::Base
  include SolrExtensionModule
  CONTENT_TYPES = %w(Article Answer HealthTip FirstAid)

  attr_accessor :user_program

  has_many :user_readings
  has_many :users, :through => :user_readings
  has_many :content_mayo_vocabularies
  has_many :mayo_vocabularies, :through => :content_mayo_vocabularies
  has_many :messages
  has_many :content_references, foreign_key: :referrer_id
  has_many :referees, through: :content_references
  has_many :factor_contents
  has_many :factors, through: :factor_contents
  has_many :program_resources, as: :resource
  has_many :programs, through: :program_resources
  belongs_to :condition
  serialize :card_actions, Array
  symbolize :card_template, in: %i(full_body abstract), allow_nil: true

  attr_accessible :title, :raw_body, :content_type, :abstract, :question, :keywords,
                  :content_updated_at, :document_id, :show_call_option,
                  :show_checker_option, :show_mayo_copyright, :type, :raw_preview,
                  :state_event, :sensitive, :symptom_checker_gender,
                  :show_mayo_logo, :has_custom_card, :card_actions, :condition,
                  :condition_id, :card_template, :card_abstract,
                  :preview_image_url

  validates :title, :raw_body, :content_type, :document_id, presence: true
  validates :show_call_option, :show_checker_option, :show_mayo_copyright,
            :sensitive, inclusion: {:in => [true, false]}
  validates :document_id, uniqueness: true
  validates :symptom_checker_gender, inclusion: {in: %w(M F)}, allow_nil: true
  validates :condition, presence: true, if: lambda{|c| c.condition_id}

  before_validation :set_defaults, on: :create

  searchable :auto_index => false do
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

  def self.non_sensitive
    where(sensitive: false)
  end

  def self.install_message
    where(:title => 'Welcome to Better!').first
  end

  def self.premium
    @premium ||= find_by_document_id('RHS-PREMIUM')
  end

  def self.explainer
    @explainer ||= find_by_document_id('RHS-EXPLAINER')
  end

  def self.free_trial
    @free_trial ||= find_by_document_id('RHS-FREETRIAL')
  end

  def self.mayo_pilot
    @mayo_pilot ||= find_by_document_id('RHS-MAYOPILOT')
  end

  def self.pregnancy
    @pregnancy ||= find_by_document_id('RHS-PREGNANCY')
  end

  def self.weightloss
    @weightloss ||= find_by_document_id('RHS-WEIGHTLOSS')
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
    if Program.general
      if Random.new.rand(0..2) == 0
        published.non_sensitive
                 .where(id: Program.general.contents.pluck(:id))
                 .where('preview_image_url IS NOT NULL')
                 .first(order: 'RAND()')
      else
        published.non_sensitive
                 .where(id: Program.general.contents.pluck(:id))
                 .first(order: 'RAND()')
      end
    else
      published.non_sensitive
               .where(:content_type => CONTENT_TYPES)
               .where('document_id != ?', MayoContent::TERMS_OF_SERVICE)
               .first(order: 'RAND()')
    end
  end

  def content_type_display
    if content_type == 'TestProcedure'
      'Test/Procedure'
    else
      content_type.underscore.humanize.titleize
    end
  end

  # TODO - programs are more than just Content, this should be moved to Card
  def self.next_for(user)
    user_program = user.user_programs[Random.new.rand(0..user.user_programs.count)] # index one larger than bounds
    return random if user_program.nil? # when the index is out of bounds

    # TODO - this isn't really the best algorithm, but the data set is typically small
    user_program.program.contents.each do |content|
      if user.cards.where(resource_id: content.id, resource_type: 'Content').empty?
        content.user_program = user_program
        return content
      end
    end

    # if the user_program was empty, hit up random
    random
  end

  def active_model_serializer
    ContentSerializer
  end

  state_machine :initial => :unpublished do
    event :publish do
      transition all => :published
    end

    event :unpublish do
      transition all => :unpublished
    end

    after_transition any => any do |content, transition|
      Sunspot.index content
      Sunspot.commit
    end
  end

  protected

  def set_defaults
    self.show_call_option = true if show_call_option.nil?
    self.show_checker_option = true if show_checker_option.nil?
    self.show_mayo_copyright = false if show_mayo_copyright.nil?
  end
end
