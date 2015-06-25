class TaskStep < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task, inverse_of: :task_steps
  belongs_to :task_step_template, inverse_of: :task_steps
  has_many :task_step_data_fields, inverse_of: :task_step,
                                   dependent: :destroy
  has_many :task_data_fields, through: :task_step_data_fields
  has_many :data_fields, through: :task_data_fields
  has_many :task_step_changes, inverse_of: :task_step,
                               dependent: :destroy
  attr_accessor :actor

  attr_accessible :task, :task_id, :task_step_template, :task_step_template_id,
                  :completed_at, :completed, :actor

  validates :task, :task_step_template, presence: true
  validate :required_task_step_data_fields_completed, if: :completed?

  after_create :create_task_step_data_fields!, if: :task_step_template
  after_update :track_changes

  delegate :description, :ordinal, :details, :template, to: :task_step_template

  def self.completed
    where('completed_at IS NOT NULL')
  end

  def self.incomplete
    where(completed_at: nil)
  end

  def completed?
    completed_at.present?
  end

  def completed=(flag)
    if flag
      self.completed_at = Time.now
    else
      self.completed_at = nil
    end
  end

  def injected_details
    inject_data_field_values(details)
  end

  def injected_template
    inject_data_field_values(template)
  end

  private

  def required_task_step_data_fields_completed
    if task_step_data_fields.required.includes(:data_field).select{|t| t.data_field.incomplete?}.any?
      errors.add(:task_step_data_fields, 'must be completed to complete task step')
    end
  end

  def create_task_step_data_fields!
    task_step_template.task_step_data_field_templates.each do |task_step_data_field_template|
      task_step_data_fields.create!(task_step_data_field_template: task_step_data_field_template,
                                    task_data_field: task.output_task_data_fields.find_by_task_data_field_template_id!(task_step_data_field_template.task_data_field_template_id))
    end
  end

  def track_update
    if changes_to_track.any?
      task_step_changes.create!(actor: actor, data: changes_to_track)
    end
  end

  def changes_to_track
    changes.slice(:created_at)
  end

  def inject_data_field_values(attr)
    return nil unless attr
    attr.gsub(RegularExpressions.capture_braces) do |match|
      task_data_field_value(match[1..-2]) || match
    end
  end

  def task_data_field_value(key)
    task.service.data_fields.includes(:data_field_template).where(data_field_templates: {name: (key)}).first.try(:data)
  end
end
