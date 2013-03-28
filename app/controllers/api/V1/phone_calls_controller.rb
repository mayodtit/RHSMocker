class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :check_params

  def create
    return render_failure({reason:'time_to_call not supplied'}, 412) unless params[:phone_call][:time_to_call].present?
    return render_failure({reason:'time_zone not supplied'}, 412) unless params[:phone_call][:time_zone].present?
    return render_failure({reason:'message_id not supplied'}, 412) unless params[:phone_call][:message_id].present?

    message = Message.find_by_id params[:phone_call][:message_id]
    return render_failure({reason:"Message with ID #{params[:phone_call][:message_id]} not found"}, 404) unless message
    return render_failure({reason:"Message with ID #{params[:phone_call][:message_id]} does not belong to this user"}, 404) unless message.user_id == current_user.id

    phone_call = PhoneCall.find_by_message_id params[:phone_call][:message_id]
    if phone_call
      PhoneCall.increment_counter(:counter, phone_call.id)
    else
      phone_call = PhoneCall.create params[:phone_call].merge({:status=>'open', :counter=>1})
    end

    if phone_call.errors.empty?
      render_success({phone_call:phone_call})
    else
      render_failure({reason:phone_call.errors.full_messages.to_sentence}, 412)
    end
  end

  def update
    return render_failure({reason:'Phone call ID not supplied'}, 412) unless params[:phone_call][:id].present?

    phone_call = PhoneCall.find_by_id params[:phone_call][:id]
    return render_failure({reason:"Phone call with ID #{params[:phone_call][:id]} not found"}, 404) unless phone_call

    if(phone_call.update_attributes params[:phone_call])
      render_success({phone_call:phone_call})
    else
      render_failure({reason:phone_call.errors.full_messages.to_sentence}, 422)
    end
  end


  def check_params
    return render_failure({reason:'Permission denied for this user to schedule a call'}) unless current_user.can_call?
    return render_failure({reason:'phone_call not supplied'}, 412) unless params[:phone_call].present?
  end

end
