class Api::V1::ExpertisesController < Api::V1::ABaseController
  before_filter :load_expertises!, only: %i(index create)
  before_filter :load_expertise!, only: %i(show update destroy)

  def index
    index_resource @expertises.serializer
  end

  def show
    show_resource @expertise.serializer
  end

  def update
    update_resouce @expertise, permitted_params.expertise
  end

  def create
    create_resource @expertises, permitted_params.expertise
  end

  def destroy
    destroy_resource @expertise
  end

  private

  def load_expertises!
    @expertises = Expertise.scoped
  end

  def load_task_category!
    @expertise = Expertise.find(params[:id])
  end
end
