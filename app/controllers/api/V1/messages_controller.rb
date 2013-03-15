class Api::V1::MessagesController < Api::V1::ABaseController
  def create
    #create encounter
    encounter = Encounter.create :status=>"open", :priority=> "medium"
    #create encounter_member entry
    encounter_user = EncountersUser.create :role=>"participator", :encounter_id=>encounter.id, :user_id=>current_user.id
    if params[:subject_user_id] && params[:subject_user_id]!=current_user.id
      encounter_subject_user = EncountersUser.create :role=>"subject", :encounter_id=>encounter.id, :user_id=>subject_user_id
    end

     #create message
     message = Message.create :body=>params[:body]
        #attach mayo_keywords
        #attach attachments
        #create and set location
     #create message_status
  end
end