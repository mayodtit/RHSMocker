class Api::V1::ServicesController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :load_member!, only: [:index, :create]
  before_filter :load_service!, only: [:show, :update]
  before_filter :load_service_template!, only: :create

  def index
    authorize! :read, Service
    services = @member.services.where(params.permit(:subject_id, :state)).order('due_at, created_at ASC')
    index_resource services.serializer, name: :services
  end

  def create
    authorize! :create, Service

    if @service_template
      authorize! :read, @service_template
      create_params = service_template_attributes
      @service = @service_template.create_service! create_params
      render_success(service: @service.serializer)
    else
      create_params = service_attributes
      create_resource Service, create_params
    end
  end

  def show
    authorize! :read, @service
    show_resource @service.serializer
  end

  def update
    authorize! :update, @service

    update_params = service_attributes

    if update_params[:state_event].present?
      update_params[:actor_id] = current_user.id
    end

    if !@service.owner_id && !update_params[:owner_id]
      update_params[:owner_id] = current_user.id
    end

    if update_params[:owner_id].present? && update_params[:owner_id].to_i != @service.owner_id
      update_params[:assignor_id] = current_user.id
    end

    update_resource @service, update_params
  end

  private

  def load_service!
    @service = Service.find params[:id]
  end

  def service_attributes
    params.require(:service).permit(
      :title, :description, :state_event, :member_id, :subject_id, :owner_id,
      :reason_abandoned, :due_at, :service_type, :service_type_id, :user_facing, :auth_token).tap do |attributes|
      attributes[:creator] = current_user
      attributes[:assignor] = current_user
      attributes[:member] = @member
    end
  end

  def service_template_attributes
    params.permit(:title, :description, :subject_id, :due_at, :owner_id, :service_template_id, :auth_token, :timed_service).tap do |attributes|
      attributes[:creator] = current_user
      attributes[:member] = @member
    end
  end

  def load_service_template!
    if params[:service_template_id]
      @service_template = ServiceTemplate.find params[:service_template_id]
    end
  end
end


