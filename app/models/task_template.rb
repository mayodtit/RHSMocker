class TaskTemplate < ActiveRecord::Base
  belongs_to :service_template
  belongs_to :modal_template
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
                  :modal_template

  validates :name, :title, presence: true
  validates :service_template, presence: true, if: :service_template_id
  validates :modal_template, presence: true, if: :modal_template_id

  before_validation :copy_title_to_name

  def calculated_due_at(time=Time.now)
    time.business_minutes_from(time_estimate.to_i)
  end

  def create_deep_copy!(override_service_template=nil)
    new_modal_template = modal_template.try(:create_copy!)
    self.class.create!(attributes.except('id', 'service_template_id', 'created_at', 'updated_at', 'modal_template_id').merge(service_template: override_service_template || service_template, modal_template: new_modal_template || modal_template))
  end

  private

  def copy_title_to_name
    if !self.name
      self.name = self.title
    end
  end
end
