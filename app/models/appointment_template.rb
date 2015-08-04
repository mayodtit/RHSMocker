class AppointmentTemplate < ActiveRecord::Base
  has_many :system_event_templates

  attr_accessible :name, :description, :title, :scheduled_at, :state, :unique_id, :version, :state_event

  validates :name, :title, presence: true
  validates :version, presence: true
  validates :version, uniqueness: { scope: :unique_id }
  validates :state, presence: true
  validates :state, uniqueness: { scope: :unique_id }, unless: :retired?

  before_validation :set_unique_id, on: :create
  before_validation :set_version, on: :create

  def self.title_search(string)
    wildcard = "%#{string}%"
    where("appointment_templates.title LIKE ?", wildcard)
  end

  def self.published
    where(state: :published)
  end

  def self.unpublished
    where(state: :unpublished)
  end

  def self.retired
    where(state: :retired)
  end

  private

  def set_unique_id
    self.unique_id ||= loop do
      new_unique_id = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_unique_id unless self.class.exists?(unique_id: new_unique_id)
    end
  end

  def set_version
    self.version = self.class.where(unique_id: unique_id).maximum(:version).try(:+, 1) || 0
  end

  state_machine :initial => :unpublished do

    event :publish do
      transition :unpublished => :published
    end

    event :retire do
      transition :published => :retired
    end

    before_transition :unpublished => :published do |appointment_template|
      appointment_template.class.published.where(unique_id: appointment_template.unique_id).each do |at|
        at.retire!
      end
    end
  end
end
