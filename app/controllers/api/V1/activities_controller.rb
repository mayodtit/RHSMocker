class Api::V1::ActivitiesController < Api::V1::ABaseController
  before_filter :load_user_services!
  before_filter :load_suggestions!
  before_filter :load_users!

  def index
    render_success(users: @users.serializer,
                   services: @user_services.serializer(shallow: true),
                   suggestions: @suggestions.serializer)
  end

  private

  def load_user_services!
    authorize! :read, Service
    @user_services = current_user.services.where(user_facing: true).includes(:subject)
  end

  def load_suggestions!
    authorize! :read, SuggestedService
    @suggestions = current_user.suggested_services
  end

  def load_users!
    @users = [current_user]
    @users << current_user.pha if current_user.pha
    @user_services.each do |s|
      @users << s.subject
      @users << s.owner
    end
    @users = @users.uniq
  end
end
