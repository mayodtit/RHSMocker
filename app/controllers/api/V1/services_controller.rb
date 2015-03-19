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
      create_params[:creator] = current_user
      create_params[:member] = @member
      create_params[:actor_id] = current_user.id
      @service = @service_template.create_service! create_params
      render_success(service: @service.serializer)
    else
      create_params = service_attributes
      create_params[:creator] = current_user
      create_params[:member] = @member
      create_params[:assignor_id] = current_user.id if create_params[:owner_id].present?
      create_params[:actor_id] = current_user.id
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
    params.require(:service).permit(:title, :description, :due_at, :state_event, :owner_id, :reason, :reason_abandoned, :member_id, :subject_id, :service_type_id, :user_facing, :user_request, :auth_token)
  end

  def service_template_attributes
    params.permit(:title, :description, :subject_id, :due_at, :owner_id, :service_type, :service_template_id, :auth_token, :user_facing, :user_request)
  end

  def load_service_template!
    if params[:service_template_id]
      @service_template = ServiceTemplate.find params[:service_template_id]
    end
  end
end


