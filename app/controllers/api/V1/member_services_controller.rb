# NOTE: Please use ServicesController update and show
class Api::V1::MemberServicesController < Api::V1::ABaseController
  before_filter :load_member!
  before_filter :load_user!
  before_filter :load_service_template!, only: :create

  def index
    authorize! :read, Service
    services = @member.services.where(params.permit(:subject_id, :state)).order('due_at, created_at ASC')
    index_resource services.serializer, name: :services
  end

  def create
    authorize! :read, @service_template
    create_params = service_template_attributes
    create_params[:creator] = current_user
    create_params[:member] = @member
    @service_template.create_service! create_params
  end
  private

  def service_template_attributes
    params.permit(:title, :description, :subject_id, :due_at, :owner_id)
  end

  def load_service_template!
    @service_template = ServiceTemplate.find params[:service_template_id]
  end

end
