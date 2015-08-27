class Api::V1::UserExpertisesController < Api::V1::ABaseController
  strong_parameters :user_id, :expertise_id

  before_filter :load_user!
  before_filter :load_user_expertise!, only: [:show, :destroy]

  def index
    index_resource(@user.user_expertises.serializer)
  end

  def show
    show_resource(@user_expertise.serializer)
  end

  def create
    params[:user_expertise][:actor_id] = current_user.id
    create_resource(@user.user_expertises, sanitize_for_mass_assignment(params[:user_expertise]))
  end

  def destroy
    destroy_resource(@user_expertise)
  end

  private

  def load_user_expertise!
    @user_expertise = @user.user_expertises.find(params[:id])
    authorize! :manage, @user_expertise
  end
end
