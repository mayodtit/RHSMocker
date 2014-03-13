class Api::V1::InverseAssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!
  before_filter :load_association!, only: [:update, :destroy]

  def index
    index_resource @associations.serializer, name: :associations
  end

  def update
    update_resource @association, association_attributes, name: :association
  end

  def destroy
    destroy_resource @association
  end

  private

  def load_associations!
    @associations = @user.inverse_associations.enabled_or_pending
  end

  def load_association!
    @association = @associations.find params[:id]
    authorize! :manage, @association
  end

  def association_attributes
    params.require(:association).permit(:state_event)
  end
end
