class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!, :only => :show

  def index
    @consults = @user.consults.with_unread_messages_count_for(@user)
    @consults = @consults.where(:status => params[:status]) if params[:status]
    index_resource(@consults.serializer(include_unread_messages_count: true), name: :encounters) and return if encounter_path?
    index_resource(@consults.serializer(include_unread_messages_count: true))
  end

  def show
    show_resource(@consult.serializer, name: :encounter) and return if encounter_path?
    show_resource(@consult.serializer)
  end

  def create
    p = create_params

    if params[:consult].try(:[], :consult_image).present?
      p.merge!(image: decode_b64_image(params[:consult][:consult_image]))
      p.delete(:consult_image)
    end

    create_resource(Consult, p, name: :encounter) and return if encounter_path?
    create_resource(Consult, p)
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
