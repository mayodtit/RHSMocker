class SystemRelativeEventTemplate < SystemEventTemplate
  attr_accessible :root_event_template_id

  belongs_to :root_event_template, class_name: "SystemEventTemplate",
                                   inverse_of: :system_relative_event_templates
  has_one :time_offset, inverse_of: :system_relative_event_template

  validates :root_event_template, presence: true
end
