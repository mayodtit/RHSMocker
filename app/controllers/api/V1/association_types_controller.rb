class Api::V1::AssociationTypesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    index_resource(AssociationType.by_relationship_type)
  end
end
