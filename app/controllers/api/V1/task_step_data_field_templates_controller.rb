class Api::V1::TaskStepDataFieldTemplatesController < Api::V1::ABaseController
  before_filter :load_task_step_template!
  before_filter :load_data_field_template!

  def create
    @task_step_template.add_data_field_template!(@data_field_template)
    render_success
  end

  def destroy
    @task_step_template.remove_data_field_template!(@data_field_template)
    render_success
  end

  private

  def load_task_step_template!
    @task_step_template = TaskStepTemplate.find(params[:task_step_template_id])
    authorize! :manage, @task_step_template
  end

  def load_data_field_template!
    @data_field_template = DataFieldTemplate.find(params[:id])
    authorize! :manage, @data_field_template
  end
end
