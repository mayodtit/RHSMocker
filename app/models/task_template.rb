class TaskTemplate < ActiveRecord::Base
  QUEUE_TYPES = %i(hcc pha nurse specialist)
  symbolize :queue, in: QUEUE_TYPES

  belongs_to :service_template
  belongs_to :modal_template
  belongs_to :task_template_set
  belongs_to :task_category
  belongs_to :expertise
  belongs_to :service_type

  has_many :tasks
  has_many :task_step_templates, inverse_of: :task_template,
                                 dependent: :destroy
  has_many :task_data_field_templates, inverse_of: :task_template,
                                       dependent: :destroy
  has_many :data_field_templates, through: :task_data_field_templates
  has_many :input_task_data_field_templates, class_name: 'TaskDataFieldTemplate',
                                             conditions: {type: :input}
  has_many :input_data_field_templates, through: :input_task_data_field_templates,
                                        source: :data_field_template
  has_many :output_task_data_field_templates, class_name: 'TaskDataFieldTemplate',
                                             conditions: {type: :output}
  has_many :output_data_field_templates, through: :output_task_data_field_templates,
                                         source: :data_field_template

  attr_accessible :name, :title, :description, :time_estimate, :priority,
                  :service_ordinal, :service_template, :service_template_id,
                  :modal_template, :task_template_set, :task_template_set_id,
                  :queue, :task_category, :task_category_id, :service_type,
                  :expertise, :expertise_id

  validates :name, :title, presence: true
  validates :service_template, presence: true, if: :service_template_id
  validates :modal_template, presence: true, if: :modal_template_id
  validates :service_type, presence: true, if: :service_type_id

  before_validation :copy_title_to_name

  def calculated_due_at(time=Time.now)
    (time || Time.now).business_minutes_from(time_estimate.to_i)
  end

  def create_deep_copy!(override_task_template_set=nil)
    transaction do
      new_task_template = self.class.create!(attributes.slice(*%w(name title description time_estimate priority service_ordinal queue task_category_id)).merge(task_template_set: override_task_template_set || task_template_set, service_template: override_task_template_set.service_template || service_template))
      new_task_template.update_attributes!(modal_template: modal_template.create_copy!) if modal_template
      task_step_templates.each do |task_step_template|
        task_step_template.create_deep_copy!(override_task_template_set.service_template, new_task_template)
      end
      new_task_template
    end
  end

  def copy_title_to_name
    if !self.name
      self.name = self.title
    end
  end
end
