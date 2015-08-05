class Api::V1::ServicesController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :load_member!, only: [:index, :create]
  before_filter :load_service!, only: [:show, :update]
  before_filter :load_service_template!, only: :create

  def index
    authorize! :read, Service
    if params[:user_facing]
      services = @member.services.where(user_facing: true).order('updated_at DESC, created_at DESC').includes(:owner, :service_type)
    else
      services = @member.services.where(params.permit(:subject_id, :state)).order("field(state, 'open', 'waiting', 'completed', 'abandoned'), due_at DESC, created_at DESC").includes(:owner, :service_type)
    end
    index_resource services.serializer(shallow: true), name: :services
  end

  def create
    authorize! :create, Service
    @service = Service.create(create_attributes)
    if @service.errors.empty?
      render_success(service: @service.serializer, entry: @service.entry.serializer)
    else
      render_failure({reason: @service.errors.full_messages.to_sentence}, 422)
    end
  end

  def show
    show_resource @service.serializer
  end

  def update
    authorize! :update, @service

    update_params = permitted_params.service_attributes

    if update_params[:state_event].present?
      update_params[:actor_id] = current_user.id
    end

    if update_params[:state_event] == 'abandon'
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
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

  def load_member!
    @member = if (params[:member_id] == 'current' || params[:user_id] == 'current')
                current_user
              else
                Member.find(params[:member_id] || params[:user_id])
              end
  end

  def load_service!
    @service = Service.find params[:id]
    authorize! :read, @service
  end

  def load_service_template!
    if params[:service_template_id]
      @service_template = ServiceTemplate.find params[:service_template_id]
      authorize! :read, @service_template
    end
  end

  def create_attributes
    permitted_params.service_attributes.tap do |attributes|
      attributes[:service_template] = @service_template
      attributes[:assignor] = current_user if attributes[:owner_id]
      attributes[:creator] = current_user
      attributes[:member] = @member
      attributes[:actor_id] = current_user.id
    end
  end
end
