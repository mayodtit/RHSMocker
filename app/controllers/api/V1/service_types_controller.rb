class Api::V1::ServiceTypesController < Api::V1::ABaseController
  def index
    authorize! :read, ServiceType
    index_resource ServiceType.order('name ASC').serializer
  end
end
