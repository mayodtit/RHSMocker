class Api::V1::TaskCategoriesController < Api::V1::ABaseController
  before_filter :load_task_categories!, only: :index
  before_filter :load_task_category!, only: :show

  def index
    index_resource @task_categories.serializer
  end

  def show
    show_resource @task_category.serializer
  end

  private

  def load_task_categories!
    @task_categories = TaskCategory.scoped
  end

  def load_task_category!
    @task_category = TaskCategory.find(params[:id])
  end
end
