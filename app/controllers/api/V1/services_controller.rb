class Api::V1::ServicesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service!

  def show
    authorize! :read, @service
    show_resource @service.serializer
  end

  def update
    authorize! :update, @service

    update_params = service_attributes

    if update_params[:state_event].present?
      update_params[:actor_id] = current_user.id
    end

    if !@service.owner_id && !update_params[:owner_id]
      update_params[:owner_id] = current_user.id
    end

    if update_params[:owner_id].present? && update_params[:owner_id].to_i != @service.owner_id
      update_params[:assignor_id] = current_user.id
    end

    update_resource @service, update_params
  end

  private

  def load_service!
    @service = Service.find params[:id]
  end

  def service_attributes
    params.require(:service).permit(
      :title, :description, :state_event, :member_id, :subject_id, :owner_id,
      :reason_abandoned, :due_at
    )
  end
end
