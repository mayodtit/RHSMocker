class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_users!, only: :index

  def index
    render_success(consult: @consult.serializer,
                   messages: messages.serializer(shallow: true),
                   users: @users.serializer)
  end

  def create
    create_resource(@consult.messages, message_attributes)
    if send_robot_response?
      send_robot_response!
    elsif needs_off_hours_response?
      send_after_hours_response!
    end
  end

  private

  def messages
    if current_user.care_provider? && @consult.initiator != current_user
      @consult.messages_and_notes
    else
      @consult.messages
    end
  end

  def load_consult!
    @consult = if params[:consult_id] == 'current'
                 @user.master_consult
               else
                 Consult.find(params[:consult_id])
               end
    raise ActiveRecord::RecordNotFound unless @consult
    authorize! :manage, @consult
  end

  def load_users!
    @users = @consult.users.to_a
    @users = @users << @user.pha if @user.pha
    @users = @users.uniq
  end

  def message_attributes
    params.require(:message).permit(:text, :image, :content_id, :symptom_id, :condition_id, :note).tap do |attributes|
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

  def send_after_hours_response!
    member = @consult.initiator
    name = (member.nickname.present? && member.nickname) || member.first_name
    pha_name = member.pha && member.pha.first_name.present? ? member.pha.first_name : 'Your PHA'

    text = <<-eos
Hi#{name.present? ? " #{name}" : ''}. #{pha_name} will follow up with you about your message. If you're experiencing new symptoms or have specific medical questions, you can talk to a Mayo Clinic nurse by tapping the following number: #{Metadata.nurse_phone_number}
    eos

    @consult.messages.create(user: Member.robot,
                             text: text,
                             created_at: Time.now + 2.seconds,
                             off_hours: true)
  end

  def needs_off_hours_response?
    return false if Role.pha.on_call?
    return false if current_user != @consult.initiator
    if now.hour > 17 # same day off hours
      return false if @consult.messages
                              .where(off_hours: true)
                              .where('created_at > ?', off_hours_start_today)
                              .any?
    elsif now.hour < 9 # yesterday off hours
      return false if @consult.messages
                              .where(off_hours: true)
                              .where('created_at > ?', off_hours_start_yesterday)
                              .any?
    end
    true
  end

  def now
    @now ||= Time.now.in_time_zone('Pacific Time (US & Canada)')
  end

  def yesterday
    @yesterday ||= now - 1.day
  end

  def off_hours_start_today
    Time.new(now.year, now.month, now.day, 17, 0, 0, now.utc_offset)
  end

  def off_hours_start_yesterday
    Time.new(yesterday.year, yesterday.month, yesterday.day, 17, 0, 0, yesterday.utc_offset)
  end
end
