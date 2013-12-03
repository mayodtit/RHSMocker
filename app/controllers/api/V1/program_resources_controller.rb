class Api::V1::ProgramResourcesController < Api::V1::ABaseController
  before_filter :load_program!
  before_filter :load_program_resource!, only: [:update, :destroy]

  def index
    index_resource @program.program_resources.serializer
  end

  def create
    create_resource @program.program_resources, program_resource_params
  end

  def update
    if @program_resource.update_attributes(program_resource_params)
      render_success(program_resources: @program.reload.program_resources.serializer)
    else
      render_failure({reason: @program_resource.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    destroy_resource @program_resource
  end

  private

  def load_program!
    @program = Program.find params[:program_id]
    authorize! :manage, @program
  end

  def load_program_resource!
    @program_resource = @program.program_resources.find params[:id]
  end

  def program_resource_params
    params.require(:program_resource).permit(:move_ordinal_after)
  end
end
