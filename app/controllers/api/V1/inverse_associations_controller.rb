class Api::V1::InverseAssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!
  before_filter :load_association!, only: [:update, :destroy]

  def index
    index_resource @associations.serializer, name: :associations
  end

  def update
    if @association.update_attributes(association_attributes)
      # TODO - keys are inverted for reverse compatibility
      render_success({association: @association.serializer,
                      users: [@association.user.serializer, @association.associate.serializer]}.tap do |hash|
                       hash.merge!(inverse_association: @association.pair.serializer) if @association.pair
                     end)
    else
      render_failure({reason: @association.errors.full_messages.to_sentence}, 422)
    end
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
