class Api::V1::ConsultsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consults!, only: :index
  before_filter :load_current!, only: :current
  before_filter :load_consult!, only: :show

  def index
    index_resource @consults.serializer
  end

  def current
    show_resource @consult.serializer
  end

  def show
    show_resource @consult.serializer
  end

  def create
    @consult = Consult.create(consult_attributes)
    if @consult.errors.empty?
      @consult = Consult.find(@consult.id) # force reload of CarrierWave image url
      render_success(consult: @consult.serializer)
    else
      render_failure({reason: @consult.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_consults!
    authorize! :read, @user
    @consults = @user.initiated_consults.where(state: params[:state] || :open)
  end

  def load_current!
    @consult = @user.master_consult
    raise ActiveRecord::RecordNotFound unless @consult
    authorize! :manage, @consult
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
                                    :state_event, :description)
  end

  def message_attributes
    attributes = params.require(:consult).permit(message: :text)
    attributes.any? ? attributes[:message] : nil
  end

  def phone_call_attributes
    attributes = params.require(:consult).permit(phone_call: [:origin_phone_number,
                                                              :to_role,
                                                              :destination_phone_number])

    if attributes[:phone_call] && attributes[:phone_call][:to_role]
      attributes[:phone_call][:to_role] = Role.find_by_name! attributes[:phone_call][:to_role]
    end

    attributes.any? ? {phone_call_attributes: attributes[:phone_call].merge!(user: @user)} : nil
  end

  def scheduled_phone_call_attributes
    attributes = params.require(:consult).permit(scheduled_phone_call: [:scheduled_at, :callback_phone_number])
    if attributes.any?
      @scheduled_phone_call = ScheduledPhoneCall.where(state: :assigned)
                                                .where(scheduled_at: Time.parse(attributes[:scheduled_phone_call][:scheduled_at]))
                                                .first!
      @scheduled_phone_call.assign_attributes(state_event: :book,
                                              user_id: @user.id,
                                              booker_id: @user.id,
                                              callback_phone_number: attributes[:scheduled_phone_call][:callback_phone_number])
      {
        user: @user,
        scheduled_phone_call: @scheduled_phone_call,
        created_at: Time.now + 30.seconds
      }
    else
      nil
    end
  end

  def pha_message
    <<-eos
Hi #{@user.salutation}!

I'm #{@scheduled_phone_call.owner.first_name} and I'll be your Personal Health Assistant.

I'm looking forward to starting our conversation with an old fashioned telephone call.

To get ready:
 - Have your insurance card ready
 - Fill out your Health Profile

Questions or cancellations? Email me at premium@getbetter.com.
    eos
  end

  def pha_message_attributes
    {
      user: @scheduled_phone_call.owner,
      text: pha_message,
      automated: true
    }
  end

  def messages_attributes
    attributes = []
    attributes << {user: @user, image: image_attributes} if image_attributes
    attributes << message_attributes.merge!(user: @user) if message_attributes
    attributes << phone_call_attributes.merge!(user: @user) if phone_call_attributes
    attributes << scheduled_phone_call_attributes.merge!(user: @user) if scheduled_phone_call_attributes
    attributes << pha_message_attributes if @scheduled_phone_call
    attributes.any? ? attributes : nil
  end

  def image_attributes
    attributes = params.require(:consult).permit(:image)
    attributes.any? ? decode_b64_image(attributes[:image]) : nil
  end
end
