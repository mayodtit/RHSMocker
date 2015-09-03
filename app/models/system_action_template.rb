class SystemActionTemplate < ActiveRecord::Base
  self.inheritance_column = nil
  TYPES = %i(system_message pha_message service task)

  belongs_to :system_event_template, inverse_of: :system_action_template
  belongs_to :content
  belongs_to :published_versioned_resource, polymorphic: true,
                                            foreign_key: :versioned_resource_unique_id,
                                            foreign_type: :versioned_resource_type,
                                            primary_key: :unique_id,
                                            conditions: {state: :published}
  belongs_to :unversioned_resource, polymorphic: true
  has_many :system_actions, inverse_of: :system_action_template
  symbolize :type, in: TYPES

  attr_accessible :system_event_template, :system_event_template_id, :type, :message_text,
                  :content, :content_id, :published_versioned_resource,
                  :unversioned_resource

  validates :system_event_template, :type, presence: true
  validates :message_text, presence: true, if: ->(s) { s.system_message? || s.pha_message? }
  validates :content, presence: true, if: :content_id
  validates :published_versioned_resource, presence: true, if: :service?
  validates :unversioned_resource, presence: true, if: :task?
  validate :resource_requirements_for_types, if: ->(s) { s.service? || s.task? }
  validate :published_versioned_resource_is_published, if: :published_versioned_resource

  before_validation :set_defaults, on: :create
  before_validation :clear_unused_fields

  TYPES.each do |template_type|
    define_method("#{template_type}?") do
      type == template_type
    end
  end

  def create_deep_copy!(new_system_event_template)
    self.class.create!(attributes.except('id', 'system_event_template_id', 'created_at', 'updated_at','versioned_resource_unique_id',
                                         'published_versioned_resource','versioned_resource_type','unversioned_resource_id',
                                         'unversioned_resource_type').merge(system_event_template: new_system_event_template))
  end

  private

  def resource_requirements_for_types
    if service?
      if !published_versioned_resource || !published_versioned_resource.is_a?(ServiceTemplate)
        errors.add(:published_versioned_resource, 'must be a Service Template')
      end
    elsif task?
      if !unversioned_resource || !unversioned_resource.is_a?(TaskTemplate)
        errors.add(:unversioned_resource, 'must be a Task Template')
      end
    end
  end

  def published_versioned_resource_is_published
    unless published_versioned_resource.published?
      errors.add(:published_versioned_resource, 'must be published')
    end
  end

  def set_defaults
    self.type ||= :system_message
    self.message_text ||= 'Placeholder text'
  end

  def clear_unused_fields
    if system_message? || pha_message?
      self.published_versioned_resource = nil
      self.unversioned_resource = nil
    elsif service?
      self.message_text = nil
      self.unversioned_resource = nil
    elsif task?
      self.message_text = nil
      self.published_versioned_resource = nil
    end
  end
end
