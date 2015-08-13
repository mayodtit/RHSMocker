class TaskTemplate < ActiveRecord::Base
  QUEUE_TYPES = %i(hcc pha nurse specialist)
  symbolize :queue, in: QUEUE_TYPES

  belongs_to :service_template
  belongs_to :modal_template
  belongs_to :task_category
  has_many :tasks
  has_many :task_template_expertises
  has_many :expertises, through: :task_template_expertises
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

  attr_accessible :name, :title, :description, :time_estimate, :priority, :service_ordinal, :service_template, :service_template_id, :modal_template, :queue, :task_category, :task_category_id

  validates :name, :title, presence: true
  validates :service_template, presence: true, if: :service_template_id
  validates :modal_template, presence: true, if: :modal_template_id

  before_validation :copy_title_to_name

  def calculated_due_at(time=Time.now)
    time.business_minutes_from(time_estimate.to_i)
  end

  def create_deep_copy!(new_service_template)
    transaction do
      new_service_template.task_templates.create!(attributes.slice(*%w(name title description time_estimate priority service_ordinal queue task_category_id))).tap do |new_task_template|
        new_task_template.update_attributes!(modal_template: modal_template.create_copy!) if modal_template
        task_step_templates.each do |task_step_template|
          task_step_template.create_deep_copy!(new_service_template, new_task_template)
        end
      end
    end
  end

  private

  def copy_title_to_name
    if !self.name
      self.name = self.title
    end
  end
end
