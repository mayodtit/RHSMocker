class Api::V1::ServicesController < Api::V1::ABaseController
  before_filter :load_user!, if: -> { params[:user_id] || params[:member_id] }
  before_filter :load_services!
  before_filter :load_service!, only: %i(show update)
  before_filter :load_service_template!, only: :create, if: -> { params[:service_template_id] }

  def index
    services = if params[:user_facing]
                 @services.where(user_facing: true)
                          .order('updated_at DESC, created_at DESC')
               else
                 @services.where(params.permit(:subject_id, :state))
                          .order("field(state, 'open', 'waiting', 'completed', 'abandoned'), due_at DESC, created_at DESC")
               end
    index_resource services.includes(:service_type, owner: :phone_numbers, member: :phone_numbers, subject: :phone_numbers).serializer
  end

  def show
    show_resource @service.serializer(include_nested: true)
  end

  def create
    authorize! :create, Service
    @service = Service.create(create_params)
    if @service.errors.empty?
      render_success(service: @service.serializer(include_nested: true), entry: @service.entry.serializer)
    else
      render_failure({reason: @service.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    authorize! :update, @service
    update_resource @service, update_params
  end

  private

  def load_user!
    @user = if params[:user_id] == 'current' || params[:member_id] == 'current'
              current_user
            else
              Member.find(params[:user_id] || params[:member_id])
            end
  end

  def load_services!
    authorize! :read, Service
    @services = @user.try(:services) || Service.scoped
  end

  def load_service!
    @service = @services.find(params[:id])
    authorize! :read, @service
  end

  def load_service_template!
    @service_template = ServiceTemplate.find params[:service_template_id]
    authorize! :read, @service_template
  end

  def create_params
    permitted_params.service_attributes.tap do |attrs|
      attrs[:service_template] = @service_template
      attrs[:member] = @user
      attrs[:creator] = current_user
      attrs[:assignor] = current_user if attrs[:owner_id]
      attrs[:actor_id] = current_user.id
    end
  end

  def update_params
    permitted_params.service_attributes.tap do |attrs|
      attrs[:actor_id] = current_user.id

      if attrs[:state_event] == 'abandon'
        attrs[:abandoner] = current_user
      end

      if !attrs[:owner_id] && !@service.owner
        attrs[:owner] = current_user
      end

      if attrs[:owner_id] && attrs[:owner_id] != @service.owner_id
        attrs[:assignor] = current_user
      end
    end
  end
end
