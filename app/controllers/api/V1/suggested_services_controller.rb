class Api::V1::SuggestedServicesController < Api::V1::ABaseController
  before_filter :load_user!, if: -> { params[:user_id] }
  before_filter :load_suggested_services!
  before_filter :load_suggested_service!, only: %i(show update)

  def index
    index_resource @suggested_services.serializer(include_nested: true)
  end

  def show
    show_resource @suggested_service.serializer(include_nested: true)
  end

  def create
    create_resource @suggested_services, action_params
  end

  def update
    authorize! :update, @suggested_service
    update_resource @suggested_service, action_params
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
    @suggested_services = @user.try(:suggested_services)
  end

  def load_suggested_service!
    @suggested_service = if @suggested_services
                           @suggested_services.find(params[:id])
                         else
                           SuggestedService.find(params[:id])
                         end
    authorize! :read, @suggested_service
  end

  def action_params
    permitted_params.suggested_service.tap do |attrs|
      attrs[:actor] = current_user
    end
  end
end
