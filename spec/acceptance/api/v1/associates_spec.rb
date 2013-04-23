require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Associate" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)

    @associate = FactoryGirl.create(:associate)
    FactoryGirl.create(:association, :user=>@user, :associate=>@associate)
  end


  put '/api/v1/associates/:id' do
  	parameter :auth_token,		"User's auth token"
    parameter :id,            "Associate's ID"
    parameter :associate,     "Contains the associate's attributes"
    parameter :first_name,    "Associate's first name"
    parameter :last_name,     "Associate's last name"
    parameter :birth_date,    "Associate's birth date"
    parameter :phone,         "Associate's phone number"
    parameter :image_url,     "Associate's picture URL"
    parameter :gender,        "Associate's gender (male, female)"
    parameter :height,        "Associate's height (cm)"

    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone, :image_url, :gender, :height]
    required_parameters :auth_token, :associate, :id

    let(:auth_token)   	{ @user.auth_token }
    let(:id)            { @associate.id }
    let(:first_name)    { "New_firstname" }
    let(:last_name)     { "New_lastname" }
    let(:birth_date)    { Date.today() }
    let(:phone)         { "1234567890" }
    let(:image_url)     { "www.google.com/andrei" }
    let(:gender)        { "male" }
    let(:height)        { 150 }

    let(:raw_post)     { params.to_json }  # JSON format request body

    example_request "[PUT] Update an associate" do
      explanation "Update's the specified associate if the user is allowed to do so"
      status.should == 200
      JSON.parse(response_body)['associate'].should be_a Hash
    end
  end

  put '/api/v1/associates/:id' do
    parameter :auth_token,    "User's auth token"
    parameter :id,            "Associate's ID"
    parameter :associate,     "Contains the associate's attributes"
    parameter :first_name,    "Associate's first name"
    parameter :last_name,     "Associate's last name"
    parameter :birth_date,    "Associate's birth date"
    parameter :phone,         "Associate's phone number"
    parameter :image_url,     "Associate's picture URL"
    parameter :gender,        "Associate's gender (male, female)"
    parameter :height,        "Associate's height (cm)"

    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone, :image_url, :gender, :height]
    required_parameters :auth_token, :associate, :id

    let(:auth_token)    { @user.auth_token }
    let(:id)            { @user2.id }
    let(:first_name)    { "New_firstname" }
    let(:last_name)     { "New_lastname" }
    let(:birth_date)    { Date.today() }
    let(:phone)         { "1234567890" }
    let(:image_url)     { "www.google.com/andrei" }
    let(:gender)        { "male" }
    let(:height)        { 150 }

    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[PUT] Update an associate (401)" do
      explanation "Update's the specified associate if the user is allowed to do so."
      status.should == 401
      JSON.parse(response_body)['reason'].should_not be_empty
    end
  end

end
