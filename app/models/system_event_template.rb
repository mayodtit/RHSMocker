class SystemEventTemplate < ActiveRecord::Base
  has_one :system_action_template, inverse_of: :system_event_template
  has_many :system_relative_event_templates, inverse_of: :root_event_template
  has_many :system_events, inverse_of: :system_event_template

  attr_accessible :name, :description, :title, :state, :unique_id, :version

  validates :name, :title, presence: true
  validates :version, presence: true
  validates :version, uniqueness: { scope: :unique_id }
  validates :state, presence: true
  validates :state, uniqueness: { scope: :unique_id }, unless: :retired?

  before_validation :set_unique_id, on: :create
  before_validation :set_version, on: :create

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

  state_machine initial: :unpublished do
    event :publish do
      transition :unpublished => :published
    end

    event :retire do
      transition :published => :retired
    end
  end
end
