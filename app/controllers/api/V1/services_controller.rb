class Api::V1::ServicesController < Api::V1::ABaseController
  before_filter :load_user!, only: [:show, :update]
  before_filter :load_member!, only: [:index, :create]
  before_filter :load_service!, only: [:show, :update]
  before_filter :load_service_template!, only: :create
  before_filter :load_user_services!, only: :activities
  before_filter :load_suggestions!, only: :activities
  before_filter :load_users!, only: :activities

  def index
    authorize! :read, Service
    services = @member.services.where(params.permit(:subject_id, :state)).order("field(state, 'open', 'waiting', 'completed', 'abandoned'), due_at DESC, created_at DESC")
    index_resource services.serializer, name: :services
  end

  def create
    authorize! :create, Service
    if @service_template
      @service = @service_template.create_service! create_params
      render_success(service: @service.serializer)
    else
      create_resource Service, create_params
    end
  end

  def show
    show_resource @service.serializer
  end

  def activities
    render_success(users: @users.serializer(shallow: true),
                   services: @user_services.serializer(shallow: true),
                   suggestions: @suggestions.serializer)
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
    @member = Member.find(params[:member_id] || params[:user_id])
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

  def load_user_services!
    authorize! :read, Service
    @user_services = current_user.services.where(user_facing: true).includes(:subject)
  end

  def load_suggestions!
    authorize! :read, SuggestedService
    @suggestions = current_user.suggested_services
  end

  def load_users!
    @users = [current_user]
    @users << current_user.pha if current_user.pha
    @user_services.each do |s|
      @users << s.subject
    end
    @users = @users.uniq
  end

  def create_params
      if @service_template.nil?
        create_params = permitted_params.service_attributes
        create_params[:assignor_id] = current_user.id if create_params[:owner_id].present?
      else
        create_params = permitted_params.service_template_attributes
      end
      create_params[:creator] = current_user
      create_params[:member] = @member
      create_params[:actor_id] = current_user.id
      create_params
  end
end


