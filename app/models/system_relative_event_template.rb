class SystemRelativeEventTemplate < SystemEventTemplate
  belongs_to :root_event_template, class_name: "SystemEventTemplate",
                                   inverse_of: :system_relative_event_templates
  has_one :time_offset, inverse_of: :system_relative_event_template,
                        validate: true,
                        autosave: true,
                        dependent: :destroy

  attr_accessible :root_event_template, :root_event_template_id, :time_offset, :time_offset_attributes

  validates :root_event_template, :time_offset, presence: true

  before_validation :set_defaults, on: :create

  accepts_nested_attributes_for :time_offset

  private

  def set_defaults
    time_offset || create_time_offset
    self.title ||= "New event template for \"#{root_event_template.title}\""
    true
  end
end
