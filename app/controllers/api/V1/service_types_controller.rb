class Api::V1::ServiceTypesController < Api::V1::ABaseController
  def index
    authorize! :read, ServiceType
    service_types = ServiceType
    service_types = service_types.where(bucket: params[:bucket]) if params[:bucket]
    index_resource service_types.order('name ASC').serializer
  end

  def buckets
    authorize! :read, ServiceType
    index_resource ServiceType::BUCKETS, name: 'buckets'
  end
end
