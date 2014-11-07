class Api::V1::TaskChangesController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    authorize! :read, TaskChange
    task_changes = TaskChange
      .where(actor_id: current_user.id).order('created_at DESC')
      .page(page).per(per)
      .includes(:actor, task: :member)

    render_success task_changes: task_changes.serializer,
                   page: page,
                   per: per,
                   total_count: task_changes.total_count
  end

  def authorize_user!
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end
end