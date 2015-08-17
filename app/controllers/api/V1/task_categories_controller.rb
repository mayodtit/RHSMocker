class Api::V1::TaskCategoriesController < Api::V1::ABaseController
  before_filter :load_task_categories!, only: %i(index create)
  before_filter :load_task_category!, only: %i(show update destroy)

  def index
    index_resource @task_categories.serializer
  end

  def show
    show_resource @task_category.serializer
  end

  def update
    update_resource @task_category, permitted_params.task_category
  end

  def create
    create_resource @task_categories, permitted_params.task_category
  end

  def destroy
    destroy_resource @task_category
  end

  private

  def load_task_categories!
    @task_categories = TaskCategory.scoped
  end

  def load_task_category!
    @task_category = TaskCategory.find(params[:id])
  end
end
