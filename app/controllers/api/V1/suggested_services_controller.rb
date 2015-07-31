class Api::V1::SuggestedServicesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_suggested_services!
  before_filter :load_suggested_service!, only: %i(show update)

  def index
    index_resource @suggested_services.serializer(include_nested: true)
  end

  def show
    show_resource @suggested_service.serializer(include_nested: true)
  end

  def update
    authorize! :update, @suggested_service
    update_resource @suggested_service, update_params
  end

  private

  def load_user!
    @user = if params[:user_id] == 'current'
              current_user
            else
              Member.find(params[:user_id])
            end
  end

  def load_suggested_services!
    raise CanCan::AccessDenied unless @user == current_user
    @suggested_services = @user.suggested_services
  end

  def load_suggested_service!
    @suggested_service = @suggested_services.find(params[:id])
    authorize! :read, @suggested_service
  end

  def update_params
    permitted_params.suggested_service.tap do |attrs|
      attrs[:actor] = current_user
    end
  end
end
