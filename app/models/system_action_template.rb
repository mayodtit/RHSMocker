class SystemActionTemplate < ActiveRecord::Base
  self.inheritance_column = nil
  TYPES = %i(system_message pha_message)

  belongs_to :system_event_template, inverse_of: :system_action_template
  belongs_to :content
  belongs_to :published_versioned_resource, polymorphic: true,
                                            foreign_key: :versioned_resource_unique_id,
                                            foreign_type: :versioned_resource_type,
                                            primary_key: :unique_id,
                                            conditions: {state: :published}
  has_many :system_actions, inverse_of: :system_action_template
  symbolize :type, in: TYPES

  attr_accessible :system_event_template, :system_event_template_id, :type, :message_text,
                  :content, :content_id, :published_versioned_resource

  validates :system_event_template, :type, presence: true
  validates :message_text, presence: true, if: ->(s) { s.system_message? || s.pha_message? }
  validates :content, presence: true, if: :content_id
  validate :published_versioned_resource_is_published, if: :published_versioned_resource

  before_validation :set_defaults, on: :create

  TYPES.each do |template_type|
    define_method("#{template_type}?") do
      type == template_type
    end
  end

  private

  def set_defaults
    self.type ||= :system_message
    self.message_text ||= 'Placeholder text'
  end

  def published_versioned_resource_is_published
    unless published_versioned_resource.published?
      errors.add(:published_versioned_resource, 'must be published')
    end
  end
end
