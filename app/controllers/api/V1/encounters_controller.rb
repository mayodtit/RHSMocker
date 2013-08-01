class Api::V1::EncountersController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_encounter!, :only => :show

  def index
    index_resource(@user.encounters)
  end

  def show
    show_resource(@encounter)
  end

  def create
    create_resource(Encounter, create_params)
  end

  private

  def load_encounter!
    @encounter = @user.encounters.find(params[:id])
    authorize! :manage, @encounter
  end

  def create_params
    {:add_user => @user}.merge!(params[:encounter] || {})
  end
end
