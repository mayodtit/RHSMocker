class Api::V1::ProgramResourcesController < Api::V1::ABaseController
  before_filter :load_program!
  before_filter :load_program_resource!, only: :destroy

  def index
    index_resource @program.program_resources
  end

  def create
    create_resource @program.program_resources, program_resource_params
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
    params.require(:program_resource).permit!
  end
end
