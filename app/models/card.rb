class Card < ActiveRecord::Base
  MAX_CONTENT_PER_USER = 7

  belongs_to :user, class_name: 'Member',
                    inverse_of: :cards
  belongs_to :resource, polymorphic: true
  belongs_to :user_program
  belongs_to :sender, class_name: 'Member'

  attr_accessible :user, :user_id, :resource, :resource_id, :resource_type,
                  :state, :state_event, :state_changed_at, :priority,
                  :user_program, :user_program_id, :sender, :sender_id

  validates :user, :resource, presence: true
  validates :user_program, presence: true, if: ->(c){c.user_program_id}
  validates :sender, presence: true, if: ->(c){c.sender_id}
  validates :state_changed_at, presence: true, unless: :unsaved?
  validates :resource_id, :uniqueness => {:scope => [:user_id, :resource_type]}

  before_validation :set_default_priority
  after_create :create_user_reading, :if => :content_card?

  def self.inbox
    where(:state => :unsaved).by_priority
  end

  def self.timeline
    where(:state => :saved).by_priority
  end

  def self.by_priority
    order('priority DESC')
  end

  def self.for_resource(resource)
    where(:resource_id => resource.id, :resource_type => resource.class.name).first
  end

  def content_card?
    resource_type.constantize == Content
  end

  private

  def set_default_priority
    if resource_type == 'Consult'
      self.priority ||= 10
    elsif resource_type == 'CustomCard'
      self.priority = resource.priority
    else
      self.priority ||= 0
    end
  end

  def create_user_reading
    UserReading.where(:user_id => user.id, :content_id => resource.id).first_or_create!
  end

  state_machine :initial => :unsaved do
    event :saved do
      transition all => :saved
    end

    event :dismissed do
      transition all => :dismissed
    end

    event :reset do
      transition all => :unsaved
    end

    before_transition any => any do |card, transition|
      card.state_changed_at ||= Time.now
    end

    after_transition any => [:saved, :dismissed] do |card, transition|
      UserReading.increment_event!(card.user, card.resource, transition.to_name) if card.content_card?
      PusherJob.new.push_content(card.user_id)
    end
  end
end
