require 'spec_helper'

describe "Messages" do 

  before :all do
    @patient = FactoryGirl.create(:user_with_email)
    @patient.login

    @patient_in_encounter = FactoryGirl.create(:user_with_email)
    @patient_in_encounter.login
    @encounter = FactoryGirl.create(:encounter, :with_messages)
    FactoryGirl.create(:encounters_user, :user=>@patient_in_encounter, :encounter=>@encounter)

    @hcp = FactoryGirl.create(:hcp_user)
    @hcp.login
  end

  context "patient" do
    it "should not be able to reply to messages if he is not the patient in the encounter" do
      post(api_v1_create_user_message_path,
        { :auth_token => @patient.auth_token,
          :encounter => {:id => @encounter.id}
        })
      JSON.parse(response.body)['reason'].should == 'Permission denied'
      response.status.should be 401
    end

    it "should be able to reply to messages if he is the patient in the encounter" do
      text = "It's getting worst."

      post(api_v1_create_user_message_path,
        { :auth_token => @patient_in_encounter.auth_token,
          :encounter => {:id => @encounter.id},
          :text => text
        })
      response.status.should be 200

      result = JSON.parse(response.body)
      result['message'].should be_a Hash
      result['message']['text'].should eq text
      result['message']['user'].should be_a Hash
      result['message']['user']['id'].should eq @patient_in_encounter.id
      result['message']['encounter_id'].should eq @encounter.id
    end
  end

  context "HCP" do
    it "should be able to reply to messages in any encounter" do
      text = "Could you elaborate?"

      post(api_v1_create_user_message_path,
        { :auth_token => @hcp.auth_token,
          :encounter => {:id => @encounter.id},
          :text => text
        })
      response.status.should be 200

      result = JSON.parse(response.body)
      result['message'].should be_a Hash
      result['message']['text'].should eq text
      result['message']['user'].should be_a Hash
      result['message']['user']['id'].should eq @hcp.id
      result['message']['encounter_id'].should eq @encounter.id
    end
  end
  
end
