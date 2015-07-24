class TaskStepTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task_template, inverse_of: :task_step_templates
  has_many :task_step_data_field_templates, inverse_of: :task_step_template,
                                            dependent: :destroy
  has_many :task_data_field_templates, through: :task_step_data_field_templates
  has_many :data_field_templates, through: :task_data_field_templates
  has_many :task_steps, inverse_of: :task_step_template

  attr_accessible :task_template, :task_template_id, :description, :ordinal,
                  :details, :template

  validates :task_template, :description, presence: true
  validates :ordinal, presence: true,
                      uniqueness: {scope: :task_template_id},
                      numericality: {only_integer: true, greater_than_or_equal_to: 0}

  before_validation :set_defaults, on: :create

  def add_data_field_template!(data_field_template)
    if d = data_field_templates.find_by_id(data_field_template.id)
      return d
    end

    if tdft = task_template.output_task_data_field_templates.find_by_data_field_template_id(data_field_template.id)
      task_step_data_field_templates.create!(task_data_field_template: tdft)
    else
      task_data_field_templates.create!(data_field_template: data_field_template,
                                        task_template: task_template,
                                        type: :output)
    end
    data_field_templates.find_by_id!(data_field_template.id)
  end

  def remove_data_field_template!(data_field_template)
    task_data_field_template = task_data_field_templates.find_by_data_field_template_id!(data_field_template.id)
    task_step_data_field_templates.find_by_task_data_field_template_id!(task_data_field_template).destroy
    task_data_field_template.destroy if task_data_field_template.reload.task_step_data_field_templates.empty?
  end

  def create_deep_copy!(new_service_template, new_task_template)
    transaction do
      new_task_template.task_step_templates.create!(attributes.slice(*%w(description ordinal details template))).tap do |new_task_step_template|
        data_field_templates.each do |data_field_template|
          new_task_step_template.add_data_field_template!(new_service_template.data_field_templates.find_by_name!(data_field_template.name))
        end
      end
    end
  end

  private

  def set_defaults
    self.ordinal ||= task_template.try(:task_step_templates).try(:select, &:ordinal).try(:max_by, &:ordinal).try(:ordinal).try(:+, 1) || 0
  end
end
