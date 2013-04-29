require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "EthnicGroups" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    FactoryGirl.create(:ethnic_group, :name=>"White")
    FactoryGirl.create(:ethnic_group, :name=>"American Indian or Alaskan Native")
    FactoryGirl.create(:ethnic_group, :name=>"Asian or Pacific Islander")
    FactoryGirl.create(:ethnic_group, :name=>"Black")
    FactoryGirl.create(:ethnic_group, :name=>"Hispanic")
  end


  get '/api/v1/ethnic_groups' do
    parameter :auth_token,  "User's auth_token"
    required_parameters :auth_token

    let(:auth_token)   { @user.auth_token }

    example_request "[GET] Get all ethnic group" do
      explanation "Returns an array of ethnic groups"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
