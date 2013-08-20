class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!, :only => :show

  def index
    if params[:status]
      index_resource(@user.consults.where(:status => params[:status]))
    else
      index_resource(@user.consults)
    end
  end

  def show
    show_resource(@consult)
  end

  def create
    create_resource(Consult, create_params)
  end

  private

  def load_consult!
    @consult = @user.consults.find(params[:id])
    authorize! :manage, @consult
  end

  def create_params
    new_params = (params[:consult] || {}).merge!(:add_user => @user)
    new_params[:initiator_id] ||= @user.id
    new_params[:subject_id] ||= @user.id
    new_params[:message].merge!(:user => @user) if new_params[:message]
    new_params
  end
end
