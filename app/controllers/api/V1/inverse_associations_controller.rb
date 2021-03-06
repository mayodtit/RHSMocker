class Api::V1::InverseAssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!
  before_filter :load_association!, only: [:update, :destroy]

  def index
    render_success(associations: @associations.serializer(scope: current_user),
                   permissions: @associations.map(&:permission).serializer)
  end

  def update
    if @association.update_attributes(association_attributes)
      # TODO - keys are inverted for reverse compatibility
      render_success({association: @association.serializer(scope: current_user),
                      permissions: [@association.permission].serializer.as_json}.tap do |hash|
                       hash.merge!(users: [@association.user.serializer, @association.associate.serializer]) unless @association.association_type.try(:hcp?)
                       hash.merge!(inverse_association: @association.pair.serializer(scope: current_user)) if @association.pair
                       hash[:permissions] << @association.pair.permission.serializer if @association.pair
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
    @associations = @user.inverse_associations.enabled_or_pending.includes(:permission)
  end

  def load_association!
    @association = @associations.find params[:id]
    authorize! :manage, @association
  end

  def association_attributes
    params.require(:association).permit(:state_event)
  end
end
