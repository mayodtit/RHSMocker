require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Diets" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    FactoryGirl.create(:diet, :name=>"Gluten-free")
    FactoryGirl.create(:diet, :name=>"Vegetarian")
    FactoryGirl.create(:diet, :name=>"Vegan")
    FactoryGirl.create(:diet, :name=>"Diary-free")
    FactoryGirl.create(:diet, :name=>"Low sodium")
    FactoryGirl.create(:diet, :name=>"Kosher")
    FactoryGirl.create(:diet, :name=>"Halal")
    FactoryGirl.create(:diet, :name=>"Organic")

  end


  get '/api/v1/diets' do
    parameter :auth_token,  "User's auth_token"
    required_parameters :auth_token

    let(:auth_token)   { @user.auth_token }

    example_request "[GET] Get all diet options" do
      explanation "Returns an array of diet options"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
