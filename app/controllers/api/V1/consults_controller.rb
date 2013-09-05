class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!, :only => :show

  def index
    @consults = @user.consults.with_unread_messages_count_for(@user)
    @consults = @consults.where(:status => params[:status]) if params[:status]
    options = Consult::BASE_OPTIONS.merge({:except => :unread_messages_count_string,
                                           :methods => :unread_messages_count}) do |k, v1, v2|
      Array.wrap(v1) << v2
    end
    index_resource(@consults.as_json(options), :encounters) and return if encounter_path?
    index_resource(@consults.as_json(options))
  end

  def show
    show_resource(@consult, :encounter) and return if encounter_path?
    show_resource(@consult)
  end

  def create
    create_resource(Consult, create_params, :encounter) and return if encounter_path?
    create_resource(Consult, create_params)
  end

  private

  def load_consult!
    @consult = @user.consults.find(params[:id])
    authorize! :manage, @consult
  end

  def create_params
    new_params = original_params.merge!(:add_user => @user)
    new_params[:initiator_id] ||= @user.id
    new_params[:subject_id] ||= @user.id
    new_params[:message].merge!(:user => @user) if new_params[:message]
    new_params
  end

  def encounter_path?
    request.env['PATH_INFO'].include?('encounter')
  end

  def original_params
    (encounter_path? ? params[:encounter] : params[:consult]) || {}
  end
end
