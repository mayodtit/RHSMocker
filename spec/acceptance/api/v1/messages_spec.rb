require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login

    encounter = FactoryGirl.create(:encounter_with_messages)
    # encounters_users =  [FactoryGirl.create(:encounters_user, :encounter=>encounter, :user=>FactoryGirl.create(:user))]
    # encounter.encounters_users = encounters_users
    # p encounter
    FactoryGirl.create(:encounters_user, :user=>@user, :encounter=>encounter)
  end

  get '/api/v1/messages' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }

    example_request "[GET] Get all of this user's encounters" do
      explanation "Returns an array of all encounters the user's involved in"
      status.should == 200
      JSON.parse(response_body)['encounters'].should be_a Array
    end
  end

end
