class TaskTemplateSetController < ApplicationController
  before_filter :load_task_template!, only: %i(show update destroy)
  before_filter :load_task_templates!, only: %i(index create)
  before_filter :load_user!

  def index
    index_resource @task_template_sets.serializer
  end

  def show
    show_resource @task_template_set.serializer
  end

  def update
    update_resource(@task_template_set, permitted_params.task_template_set)
  end

  def create
    create_resource(@task_template_sets, permitted_params.task_template_set)
  end

  def destroy
    destroy_resource @task_template_set
  end

  private

  def load_task_template_set!
    @task_template_set = TaskTemplateSet.find(params[:id])
    authorize! :manage, @task_template_set
  end

  def load_task_templates!
    @task_template_sets = TaskTemplateSet.where(params.permit(:service_template_id))
  end
end
