class Api::V1::MessagesController < Api::V1::ABaseController
  def create

    if params[:encounter_id].present?
      encounter = Encounter.find_by_id params[:encounter_id]
      return render_failure(reason:"Encounter with id #{params[:encounter_id]} is not found", 404) unless encounter
    else
      #create encounter
      encounter = Encounter.create :status=>"open", :priority=> "medium"
    end

    #create encounter_member entry
    encounter_user = EncountersUser.find_or_create_by_encounter_id_and_user_id encounter.id, current_user.id
    encounter_user.update_attribute :role, "participator"
    if params[:subject_user_id] && params[:subject_user_id]!=current_user.id
      encounter_subject_user = EncountersUser.find_or_createby_encounter_id_and_user_id encounter.id, ubject_user_id
    end


    #create message
    message = Message.create :body=>params[:body]

    #attach mayo_keywords
    if params[:keywords].present?
      params[:keywords].each do |keyword_name|
        keyword = MayoVocabulary.find_by_name keyword_name
        message.mayo_vocabulary << keyword
      end
    end

    #attach attachments
    if params[:attachments].present?
      params[:attachments].each do |attachment_url|
        attachment = Attachment.create :url => attachment_url
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


  end


  def list
    return render_successful encounters:current_user.encounters
  end
end
