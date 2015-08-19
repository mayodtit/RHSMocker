class SystemEventTemplate < ActiveRecord::Base
  has_one :system_action_template, inverse_of: :system_event_template
  belongs_to :resource, polymorphic: true
  has_many :system_relative_event_templates, foreign_key: :root_event_template_id,
                                             inverse_of: :root_event_template
  has_many :system_events, inverse_of: :system_event_template

  attr_accessible :name, :description, :title, :state, :unique_id, :version, :resource, :resource_id, :resource_type, :resource_attribute

  VALID_STATES = [:unpublished, :published, :retired]

  validates :name, :title, :state, presence: true
  validates :state, uniqueness: { scope: :unique_id }, unless: :retired?
  validates :version, presence: true, uniqueness: { scope: :unique_id }

  before_validation :set_unique_id, on: :create
  before_validation :set_version, on: :create

  VALID_STATES.each do |state|
    self.singleton_class.send(:define_method, state.to_s) do
      where(state: state)
    end
  end

  def self.title_search(string)
    wildcard = "%#{string}%"
    where("system_event_templates.title LIKE ?", wildcard)
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

  state_machine initial: :unpublished do
    event :publish do
      transition :unpublished => :published
    end

    event :retire do
      transition :published => :retired
    end
  end
end
