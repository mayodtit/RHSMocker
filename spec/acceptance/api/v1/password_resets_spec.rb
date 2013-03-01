require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PasswordResets" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
  end

  post '/api/v1/password_resets' do
    parameter :email, "User's email address"
    required_parameters :email

    let(:email)     { @user.email }
    let(:raw_post)  { params.to_json }  # JSON format request body

    example_request "Reset the Password (Forgot Password)" do
      explanation "Emails password reset instructions to the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
