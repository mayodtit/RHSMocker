class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!

  def index
    render_success(consult: @consult.serializer,
                   messages: @consult.messages.serializer,
                   users: @consult.users.uniq.serializer)
  end

  def create
    create_resource(@consult.messages, message_attributes)
    send_robot_response! if send_robot_response?
  end

  private

  def load_consult!
    @consult = if params[:consult_id] == 'current'
                 @user.master_consult
               else
                 Consult.find(params[:consult_id])
               end
    authorize! :manage, @consult
  end

  def message_attributes
    params.require(:message).permit(:text, :image).tap do |attributes|
      attributes[:user] = current_user
      attributes[:image] = decode_b64_image(attributes[:image]) if attributes[:image]
    end
  end

  def send_robot_response!
    @consult.messages.create(user: Member.robot,
                             text: "We have received your message and your PHA will get back to you shortly. Thank you.",
                             created_at: Time.now + 1.second)
  end

  def send_robot_response?
    !(Metadata.find_by_mkey('remove_robot_response').try(:mvalue) == 'true')
  end
end
