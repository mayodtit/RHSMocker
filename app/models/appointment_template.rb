class AppointmentTemplate < ActiveRecord::Base
  has_one :scheduled_at_system_event_template, class_name: 'SystemEventTemplate',
                                               as: :resource,
                                               conditions: {resource_attribute: :scheduled_at},
                                               dependent: :destroy
  has_one :discharged_at_system_event_template, class_name: 'SystemEventTemplate',
                                                as: :resource,
                                                conditions: {resource_attribute: :discharged_at},
                                                dependent: :destroy

  attr_accessible :title, :description, :state, :unique_id, :version, :state_event, :special_instructions, :reason_for_visit, :scheduled_at_system_event_template, :discharged_at_system_event_template, :scheduled_at_system_event_template_attributes, :discharged_at_system_event_template_attributes

  validates :title, :state, :version, presence: true
  validates :version, uniqueness: { scope: :unique_id }
  validates :state, uniqueness: { scope: :unique_id }, unless: :retired?

  before_validation :set_unique_id, on: :create
  before_validation :set_version, on: :create

  accepts_nested_attributes_for :scheduled_at_system_event_template, :discharged_at_system_event_template

  def create_deep_copy!
    transaction do
      self.class.create!(attributes.except('id', 'version', 'state', 'created_at', 'updated_at'))
    end
  end

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
