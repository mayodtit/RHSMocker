class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consults!, only: :index
  before_filter :load_consult!, only: :show

  def index
    index_resource @consults.serializer
  end

  def show
    show_resource @consult.serializer
  end

  def create
    create_resource Consult, consult_attributes
  end

  private

  def load_consults!
    @consults = @user.initiated_consults.where(state: params[:state] || :open)
  end

  def load_consult!
    @consult = Consult.find(params[:id])
    authorize! :manage, @consult
  end

  def consult_attributes
    permitted_attributes.tap do |attributes|
      attributes[:initiator_id] ||= @user.id
      attributes[:subject_id] ||= @user.id
      attributes[:messages_attributes] = messages_attributes if messages_attributes
      attributes[:image] = image_attributes if image_attributes
    end
  end

  def permitted_attributes
    params.require(:consult).permit(:title, :initiator_id, :subject_id,
                                    :state_event)
  end

  def message_attributes
    attributes = params.require(:consult).permit(message: :text)
    attributes.any? ? attributes[:message] : nil
  end

  def phone_call_attributes
    attributes = params.require(:consult).permit(phone_call: [:origin_phone_number,
                                                              :destination_phone_number])
    attributes.any? ? {phone_call_attributes: attributes[:phone_call].merge!(user: @user)} : nil
  end

  def scheduled_phone_call_attributes
    attributes = params.require(:consult).permit(scheduled_phone_call: :scheduled_at)
    attributes.any? ? {scheduled_phone_call_attributes: attributes[:scheduled_phone_call].merge!(user: @user)} : nil
  end

  def messages_attributes
    attributes = []
    attributes << {user: @user, image: image_attributes} if image_attributes
    attributes << message_attributes.merge!(user: @user) if message_attributes
    attributes << phone_call_attributes.merge!(user: @user) if phone_call_attributes
    attributes << scheduled_phone_call_attributes.merge!(user: @user) if scheduled_phone_call_attributes
    attributes.any? ? attributes : nil
  end

  def image_attributes
    attributes = params.require(:consult).permit(:image)
    attributes.any? ? decode_b64_image(attributes[:image]) : nil
  end
end
