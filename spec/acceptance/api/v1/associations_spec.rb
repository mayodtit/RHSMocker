require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Association" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let(:user_id) { user.id }

  before do
    User.any_instance.stub(:taxonomy_classification).and_return("trust me i'm a doctor")
  end

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  get '/api/v1/users/:user_id/associations' do
    let!(:association) { create(:association, user: user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all associations for a user" do
      explanation 'Returns an array of associations for the user'
      status.should == 200
      JSON.parse(response_body)['associations'].should be_a Array
    end
  end

  get '/api/v1/users/:user_id/associations/:id' do
    let!(:association) { create(:association, user: user) }
    let(:id) { association.id }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get an association for a user" do
      explanation 'Returns an association for the user'
      status.should == 200
      association = JSON.parse(response_body)['association']
      association.should be_a Hash

      # don't include sensitive data in a user's JSON
      excluded_columns = %w(auth_token created_time crypted_password google_analytics_uuid salt stripe_customer_id salt updated_at)
      excluded_columns.each do |column|
        association['associate'].keys.should_not include(column)
      end
    end
  end

  post '/api/v1/users/:user_id/associations' do
    let!(:association_type) { create(:association_type) }

    parameter :first_name, "Associate's first name"
    parameter :last_name, "Associate's last name"
    parameter :birth_date, "Associate's birth date"
    parameter :phone, "Associate's phone number"
    parameter :avatar, 'Base64 encoded image'
    parameter :gender, "Associate's gender (male, female)"
    parameter :height, "Associate's height (cm)"
    parameter :provider_taxonomy_code, "Associate's healthcare provider taxonomy code"
    parameter :association_type_id, "Association type"
    parameter :is_default_hcp, "Set associate to user's default HCP if value is true"
    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone,
                                  :avatar, :gender, :height, :provider_taxonomy_code]
    scope_parameters :association, [:associate]
    required_parameters :association_type_id

    let(:first_name) { "Kyle" }
    let(:last_name) { "Chilcutt" }
    let(:birth_data) { Date.today }
    let(:phone) { '123-456-7890' }
    let(:gender) { 'male' }
    let(:height) { 180 }
    let(:provider_taxonomy_code) { 'abcde' }
    let(:association_type_id) { association_type.id }
    let(:is_default_hcp) { "false" }
    let(:raw_post) { params.to_json }
    # purposely don't include avatar

    example_request "[POST] Create an association for a user" do
      explanation 'Create an association for the user'
      status.should == 200

      response = JSON.parse(response_body, :symbolize_names => true)[:association]
      response[:is_default_hcp].should be_false
      response[:associate][:provider_taxonomy_code].should eq('abcde')
      response[:associate][:taxonomy_classification].should eq("trust me i'm a doctor")
      response[:associate].keys.should include(:avatar_url)
      response[:associate][:avatar_url].should be_nil # check for non_nil avatar in 'update specific association' spec
    end
  end

  put '/api/v1/users/:user_id/associations/:id' do
    let!(:association) { create(:association, user: user) }
    let!(:association_type) { create(:association_type) }
    let(:id) { association.id }

    parameter :id, "Association's ID"
    parameter :association_type_id, "Association type"
    parameter :is_default_hcp, "Set associate to user's default HCP if value is true"
    required_parameters :id

    let(:association_type_id) { association_type.id }
    let(:is_default_hcp) { true }
    let(:raw_post) { params.to_json }

    example_request "[PUT] Update an association for a user" do
      explanation 'Update an association for the user'
      status.should == 200
      response = JSON.parse(response_body, symbolize_names: true)
      response[:association][:association_type_id].should == association_type.id
      response[:association][:is_default_hcp].should be_true
    end
  end

  delete '/api/v1/users/:user_id/associations/:id' do
    let!(:association) { create(:association, user: user) }
    let(:id) { association.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Delete an association for a user" do
      explanation 'Delete an association for the user'
      status.should == 200
    end
  end

  post '/api/v1/users/:user_id/associations/:id/invite' do
    let!(:associate) { create(:user, owner: user, email: 'kyle@test.getbetter.com') }
    let!(:association) { create(:association, user: user, associate: associate) }
    let(:id) { association.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Invite a family member to connect' do
      explanation 'Invite a member to connect through a family member association'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:association].to_json).to eq(association.reload.pair.serializer.as_json.to_json)
    end
  end
end
