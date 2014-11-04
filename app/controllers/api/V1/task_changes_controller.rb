class Api::V1::TaskChangesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :authorize_user!

  def index
    index_resource TaskChange.where( actor_id: current_user.id).order('created_at DESC').includes(:task, :actor).serializer
  end

  def authorize_user!
    authorize! :read, Task
  end
end