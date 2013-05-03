class Api::V1::AssociationTypesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def list
    render_success(association_types:Set.new(AssociationType.all).classify{|at| at.relationship_type })
  end
end
