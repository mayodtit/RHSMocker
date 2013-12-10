class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consults!, only: :index
  before_filter :load_consult!, only: :show

  def index
    index_resource @consults.serializer(include_unread_messages_count: true)
  end

  def show
    show_resource @consult.serializer
  end

  def create
    create_resource Consult, consult_attributes
  end

  private

  def load_consults!
    @consults = @user.consults.with_unread_messages_count_for(@user)
    @consults = @consults.where(status: params[:status]) if params[:status]
  end

  def load_consult!
    @consult = @user.consults.find(params[:id])
    authorize! :manage, @consult
  end

  def consult_attributes
    (params[:consult] || {}).tap do |attributes|

      # add participating users to consult if they are not already present
      attributes.merge!(add_user: @user)
      attributes[:initiator_id] ||= @user.id
      attributes[:subject_id] ||= @user.id

      if attributes[:message]
        # add current user as message sender
        attributes[:message].merge!(user: @user)
      elsif attributes[:description] || attributes[:image]
        # duplicate the consult description and image as the first message
        attributes[:message] = {user: @user, text: attributes[:description]}
        attributes[:message].merge!(image: decode_b64_image(attributes[:image])) if attributes[:image]
      end

      attributes[:image] = decode_b64_image(attributes[:image]) if attributes[:image]
    end
  end
end
