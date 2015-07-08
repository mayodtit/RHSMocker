class Api::V1::TaskTemplateSetsController < Api::V1::ABaseController
  before_filter :load_task_template_set!, only: %i(show update destroy)
  before_filter :load_task_template_sets!, only: %i(index create)
  before_filter :load_user!

  def index
    index_resource @task_template_sets.serializer
  end

  def show
    show_resource @task_template_set.serializer
  end

  def update
    if params[:task_template_set].try(:[], :affirmative_child_id) || params[:task_template_set].try(:[], :negative_child_id)
      @task_template_set.create_child_association!(permitted_params.task_template_set[:affirmative_child_id], permitted_params.task_template_set[:negative_child_id])
    elsif params[:task_template_set].try(:[], :parent_id) # for the cases except the first TaskTemplateSet
      @task_template_set.create_parent_association!(permitted_params.task_template_set[:parent_id])
    end
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

  def load_task_template_sets!
    @task_template_sets = TaskTemplateSet.where(params.permit(:service_template_id))
  end
end
