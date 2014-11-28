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
    messages = @consult.messages
    messages = @consult.messages_and_notes if current_user.care_provider? && @consult.initiator != current_user
    messages = messages.where('created_at > ?', Time.parse(params[:last_message_date])) if params[:last_message_date].present?
    messages
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
      attributes[:user] = current_user.impersonated_user || current_user
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
                             off_hours: true,
                             system: true)
  end

  def needs_off_hours_response?
    return false if Role.pha.on_call?
    return false if current_user != @consult.initiator
    return false if current_session.device_app_version && (Gem::Version.new(current_session.device_app_version) >= Gem::Version.new('1.3.0'))
    return false if @consult.messages
                            .where(off_hours: true)
                            .where('created_at > ?', off_hours_start)
                            .any?
    true
  end

  def off_hours_start
    if now.saturday?
      off_hours_start_yesterday
    elsif now.sunday?
      off_hours_start_day_before_yesterday
    elsif now.hour > (ON_CALL_END_HOUR - 1)
      off_hours_start_today
    elsif now.hour <  ON_CALL_START_HOUR # yesterday off hours
      off_hours_start_yesterday
    else # maybe holiday? we shouldn't normally be here
      off_hours_start_yesterday
    end
  end

  def now
    @now ||= Time.now.in_time_zone('Pacific Time (US & Canada)')
  end

  def yesterday
    @yesterday ||= now - 1.day
  end

  def day_before_yesterday
    @day_before_yesterday ||= now - 2.days
  end

  def off_hours_start_today
    Time.new(now.year, now.month, now.day, 21, 0, 0, now.utc_offset)
  end

  def off_hours_start_yesterday
    Time.new(yesterday.year, yesterday.month, yesterday.day, 21, 0, 0, yesterday.utc_offset)
  end

  def off_hours_start_day_before_yesterday
    Time.new(day_before_yesterday.year, day_before_yesterday.month, day_before_yesterday.day, 21, 0, 0, day_before_yesterday.utc_offset)
  end
end
