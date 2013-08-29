class Api::V1::ConsultUsersController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!

  def index
    index_resource(@consult.users)
  end

  private

  def load_consult!
    @consult = Consult.find(params[:consult_id])
    authorize! :manage, @consult
  end
end
