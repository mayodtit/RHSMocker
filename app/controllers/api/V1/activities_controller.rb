class Api::V1::ActivitiesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service!, only: :show
  before_filter :load_services, only: :index
  before_filter :load_suggestions!, only: :index

  def index
    index_resource @service_templates.serializer
  end

  def activites
    render_success(
                   users: @users.serializer,
                   total_count: @total_count_per_user)
  end

  def show
    show_resource @service.serializer.try(:serializer, for_activity: true)
  end

  private

  def load_services!
    authorize! :read, Service
    @services = Service.where(member: current_user, user_facing: true)
  end

  def in_progress_activities
    @services.open_state
  end

  def completed_activities
    @services.closed_state
  end

  def load_service!
    @service = Service.find params[:id]
    authorize! :read, @service
  end

  def load_suggestions
    authorize! :read, ServiceTemplate
    @suggested_templates = ServiceTemplate.where(suggestion: true)
  end

end
