class Api::V1::MessagesController < Api::V1::ABaseController

  def create
    warnings = []

    if params[:encounter].present? && params[:encounter][:id].present?
      encounter = Encounter.find_by_id params[:encounter][:id]
      return render_failure({reason:"Encounter with id #{params[:encounter][:id]} is not found"}, 404) unless encounter
      encounter_user = EncountersUser.find_by_encounter_id_and_user_id encounter.id, current_user.id
      return render_failure({reason:"Permission denied"}) unless encounter_user || current_user.admin?
    else
      #create encounter
      priority = params[:encounter].present? && params[:encounter][:priority].present? ? params[:encounter][:priority] : "medium"
      encounter = Encounter.create :status=>"open", :priority=> priority
    end

    #create encounter_member entry
    encounter_user ||= EncountersUser.find_or_create_by_encounter_id_and_user_id encounter.id, current_user.id

    if params[:patient_user_id] && params[:patient_user_id]!=current_user.id
      encounter_user.update_attribute :role, "participator"
      return render_failure({reason:"User with id #{params[:patient_user_id]} was not found"}, 404) unless User.find_by_id(params[:patient_user_id])
      encounter_subject_user = EncountersUser.find_or_create_by_encounter_id_and_user_id encounter.id, params[:patient_user_id]
    else
      encounter_user.update_attribute :role, "patient"
      encounter.update_attribute :checked, false
    end

    #create message
    message = Message.create :text=>params[:text]
    message.encounter = encounter
    message.user = current_user

    #attach mayo_keywords
    if params[:keywords].present?
      params[:keywords].each do |keyword_name|
        keyword = MayoVocabulary.find_by_title keyword_name
        if keyword
          MayoVocabulariesMessage.create(:mayo_vocabulary_id=>keyword.id, :message_id=>message.id)
        else
          warnings << "Keyword #{keyword_name} was not found"
        end
      end
    end

    #attach attachments
    if params[:attachments].present?
      params[:attachments].each do |attachment_json|
        attachment = Attachment.create :url => attachment_json[:url]
        message.attachments << attachment
      end
    end

    #create and set location
    location_json = params[:location]
    if location_json
      location = UserLocation.create :longitude=>location_json[:longitude], :latitude=>location_json[:latitude]
      message.user_location = location
    end

    #create message_status
    encounter.encounters_users.each do |encounter_user|
      status_name = (encounter_user.user_id == current_user.id) ? "read" : "unread"
      MessageStatus.create(:status=>status_name, :user_id=>encounter_user.user_id, :message=>message)
    end

    if message.save
      render_success({message:message.as_json({:current_user=>current_user}), warnings:warnings})
    else
      render_failure( {reason:message.errors.full_messages.to_sentence}, 400 )
    end
  end


  def list
    render_success encounters:current_user.encounters.as_json({:current_user=>current_user})
  end

  def mark_read
    warnings = []

    return render_failure({reason:"Did not pass an array of [messages]"}, 417) unless params[:messages].present?
    params[:messages].each do |message_json|
      message = Message.find_by_id message_json[:id]
      if message
        encounters_user = EncountersUser.find_by_encounter_id_and_user_id message.encounter_id, current_user.id
        if encounters_user.nil?
          if current_user.admin?
            encounters_user = EncountersUser.create :encounter=>message.encounter, :user=>current_user, :role=>"reader"
          else
            warnings << "Permission denied to mark message with id #{message_json[:id]} as read"
            next
          end
        end
        if encounters_user.role != "patient" && current_user.admin?
          message.encounter.update_attribute :checked, true
        end

        message_status = MessageStatus.find_or_create_by_message_id_and_user_id message.id, current_user.id
        message_status.update_attribute :status, "read"
      else
        warnings << "Message with id #{message_json.id} not found"
      end
    end
    render_success({warnings:warnings})
  end

end
