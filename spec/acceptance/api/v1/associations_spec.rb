require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Associations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)

    @disease = FactoryGirl.create(:disease)
    @user_disease = FactoryGirl.create(:user_disease, :disease=>@disease)
    @treatment = FactoryGirl.create(:treatment)
    @user_disease_treatment = FactoryGirl.create(:user_disease_treatment, :user_disease=>@user_disease, :treatment=>@treatment)
    @allergy = FactoryGirl.create(:allergy)
    @associate = FactoryGirl.create(:associate, :user_diseases=>[@user_disease], :allergies=>[@allergy])
    @association_type = FactoryGirl.create(:association_type)
    @association = FactoryGirl.create(:association, :user=>@user, :associate=>@associate, :association_type=>@association_type)



    associate2 = FactoryGirl.create(:associate, :diseases=>[@disease], :first_name=>"Alex")
    @association_type2 = FactoryGirl.create(:association_type, :name=>"brother")
    @association2 = FactoryGirl.create(:association, :user=>@user2, :associate=>associate2, :association_type=>@association_type2)


    associate3 = FactoryGirl.create(:associate)
    @association3 = FactoryGirl.create(:association, :user=>@user, :associate=>associate3, :association_type=>@association_type)
  end


  get '/api/v1/associations' do
    parameter :auth_token,      "User's auth token"
    required_parameters :auth_token

    let(:auth_token)   { @user.auth_token }

    example_request "[GET] Get user's associations" do
      explanation "Returns an array of the user's associations (relationships)"
      status.should == 200
      JSON.parse(response_body)['associations'].should be_a Array
    end
  end


  get '/api/v1/associations' do
    parameter :auth_token,      "User's auth token"
    parameter :user_id,         "User id of the associate that you want to see the associations for"
    required_parameters :auth_token

    let(:auth_token)   { @user.auth_token }
    let(:user_id)   { @associate.id }

    example_request "[GET] Get associate's associations" do
      explanation "Returns an array of the associate's associations (relationships)"
      puts response_body
      status.should == 200
      JSON.parse(response_body)['associations'].should be_a Array
    end
  end


  describe 'create an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the associate parameter"
    parameter :user_id, 'ID of the user for which to create an association; current_user is assumed if omitted'
    parameter :association_type_id,        "The id of the association type. The relation of the associate (sister, doctor)"
    parameter :associate,       "Attributes of the associate"
    parameter :first_name, "First name of the associate"
    parameter :last_name, "Last name of the associate"
    parameter :email, "Email of the associate"
    parameter :image_url,   "Associate's image URL"
    parameter :gender,   "Associate's gender(male or female)"
    parameter :height,   "Associate's height(in cm)"
    parameter :birth_date,   "Associate's birth date"
    parameter :phone,   "Associate's phone number"
    parameter :generic_call_time,   "Associate's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket,   "Associate's feature bucket (none message_only call_only message_call)"
    parameter :ethnic_group_id, "Associate's ethnic group"
    parameter :diet_id, "Associate's diet id"
    parameter :blood_type, "Associate's blood type"
    parameter :holds_phone_in, "The hand the associate holds the phone in (left, right)"

    scope_parameters :association, [:user_id, :associate, :association_type_id]
    scope_parameters :associate, [ :email, :feature_bucket, :first_name, :last_name, :image_url,\
     :gender, :height, :birth_date, :phone, :generic_call_time, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in]

    required_parameters :auth_token, :association, :association_type_id


    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:association_type_id)      { @association_type.id }
      let(:associate)    { nil }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association" do
        explanation "Create an association between the user and the specified associate"
        status.should == 200
        JSON.parse(response_body)['association'].should be_a Hash
      end
    end

    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:user_id) { @user.id }
      let(:association_type_id)      { @association_type.id }
      let(:email)          { "tst@test.com" }
      let(:password)       { "11111111" }
      let(:feature_bucket) { "message_only" }
      let(:first_name)     { "Bob" }
      let(:last_name)      { "Smith" }
      let(:image_url)      { "http://placekitten.com/90/90" }
      let(:gender)      { "male" }
      let(:height)      { 190 }
      let(:birth_date)      { "1980-10-15" }
      let(:phone)      { "4163442356" }
      let(:generic_call_time)      { "morning" }
      let(:ethnic_group_id)      { 1 }
      let(:diet_id)      { 1 }
      let(:blood_type)      { "B-positive" }
      let(:holds_phone_in)      { "left" }
      let(:raw_post)     { {"auth_token"=>params["auth_token"], "association"=>{"association_type_id"=>params["association"]["association_type_id"], "associate"=>params["associate"]}}.to_json }  # JSON format request body

      example_request "[POST] Create an association full" do
        explanation "Create an association between the user and the specified associate"
        status.should == 200
        JSON.parse(response_body)['association'].should be_a Hash
      end
    end


    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:association_type_id)      { "343" }
      let(:associate)    { nil }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association b (404)" do
        explanation "Create an association between the user and the specified associate. Invalid association_type_id."
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association c (412)" do
        explanation "Create an association between the user and the specified associate"
        status.should == 412
      end
    end

  end


  describe 'update an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the association's attributes"
    parameter :id,              "Association ID"
    parameter :association_type_id,        "The id of the association type. The relation of the associate (sister, doctor)"

    scope_parameters :association, [:id, :association_type_id]
    required_parameters :auth_token, :association, :id


    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association.id }
      let(:association_type_id)      { @association_type.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 200
        JSON.parse(response_body)['association'].should be_a Hash
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { 1234 }
      let(:association_type_id)      { @association_type.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association b (404)" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association2.id }
      let(:association_type_id)      { @association_type.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association c (401)" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association.id }
      let(:association_type_id)      { "43" }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association d (404)" do
        explanation "Update an association between the user and the specified associate (by ID). Invalid association_type_id."
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'delete an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the ID parameter"
    parameter :id,              "Association ID"

    scope_parameters :association, [:id]
    required_parameters :auth_token, :association, :id


    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { @association.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association" do
        explanation "Deletes the specified association"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { 1234 }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association b (404)" do
        explanation "Deletes the specified association"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { @association2.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association c (401)" do
        explanation "Deletes the specified association"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
