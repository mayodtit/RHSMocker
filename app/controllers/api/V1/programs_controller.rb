class Api::V1::ProgramsController < Api::V1::ABaseController
  before_filter :authorize_user!
  before_filter :load_program!, only: [:show, :update]

  def index
    index_resource Program.all
  end

  def show
    show_resource @program
  end

  def create
    create_resource Program, program_params
  end

  def update
    update_resource @program, program_params
  end

  private

  def authorize_user!
    authorize! :manage, Program
  end

  def load_program!
    @program = Program.find params[:id]
  end

  def program_params
    params[:program].permit(:title)
  end
end
