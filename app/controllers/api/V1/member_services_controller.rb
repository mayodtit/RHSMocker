# NOTE: Please use ServicesController update and show
class Api::V1::MemberServicesController < Api::V1::ABaseController
  before_filter :load_member!

  def index
    authorize! :read, Service
    services = @member.services.where(params.permit(:subject_id, :state)).order('due_at, created_at ASC')
    index_resource services.serializer, name: :services
  end
end
