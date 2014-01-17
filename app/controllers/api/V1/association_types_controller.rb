class Api::V1::AssociationTypesController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_association_types!

  def index
    index_resource(@association_types)
  end

  private

  def load_association_types!
    @association_types = AssociationType.by_relationship_type
                                        .merge(AssociationType.defaults)
  end
end
