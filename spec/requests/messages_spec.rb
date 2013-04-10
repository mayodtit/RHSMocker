require 'spec_helper'

describe "Messages" do 

  before :all do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @encounter = FactoryGirl.create(:encounter_with_messages)
  end

  it "should not let patient reply to messages if that user is not the patient in that encounter" do
    post(api_v1_create_user_message_path,
      { :auth_token => @user.auth_token,
        :encounter => {:id => @encounter.id}
      })
    JSON.parse(response.body)['reason'].should == 'Permission denied'
    response.status.should be 401
  end
  
end
