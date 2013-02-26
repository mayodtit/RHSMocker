require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  before(:each) do
    # @user = Fabricate(:user)
    # @user.login
  end

  post '/api/v1/signup' do
    parameter :install_id, "Unique install_id"
    scope_parameters :user, [:install_id]

    required_parameters :install_id

    let (:install_id) { "1234" }

    example_request "Signup Using install_id" do
      explanation "Signing up the user using only the install_id"

      resp = JSON.parse response_body

      status.should == 200
    end

  end

  post '/api/v1/signup' do
    parameter :install_id, "Unique install_id"
    parameter :email, "Account email"
    parameter :password, "Account password"
    scope_parameters :user, [:install_id]

    required_parameters :install_id

    let (:install_id) { "1234" }
    let (:email) {"tst@test.com"}
    let (:password){ "111111"}

    example_request "Signup Using Email and Password" do
      explanation "Signing up (or upgrade) the user using email"

      resp = JSON.parse response_body

      status.should == 200
    end

  end
end
