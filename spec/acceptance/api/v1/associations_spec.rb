require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Association" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let(:user_id) { user.id }

  before(:each) do
    user.login
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
    parameter :association_type_id, "Association type"
    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone,
                                  :avatar, :gender, :height]
    scope_parameters :association, [:associate]
    required_parameters :association_type_id

    let(:first_name) { "Kyle" }
    let(:last_name) { "Chilcutt" }
    let(:birth_data) { Date.today }
    let(:phone) { '123-456-7890' }
    let(:gender) { 'male' }
    let(:height) { 180 }
    let(:association_type_id) { association_type.id }
    let(:raw_post) { params.to_json }
    # purposely don't include avatar

    example_request "[POST] Create an association for a user" do
      explanation 'Create an association for the user'
      status.should == 200

      response = JSON.parse(response_body, :symbolize_names => true)[:association][:associate]
      response.keys.should include(:avatar_url)
      response[:avatar_url].should be_nil # check for non_nil avatar in 'update specific association' spec
    end
  end

  put '/api/v1/users/:user_id/associations/:id' do
    let!(:association) { create(:association, user: user) }
    let!(:association_type) { create(:association_type) }
    let(:id) { association.id }

    parameter :id, "Association's ID"
    parameter :association_type_id, "Association type"
    required_parameters :id

    let(:association_type_id) { association_type.id }
    let(:raw_post) { params.to_json }

    example_request "[PUT] Update an association for a user" do
      explanation 'Update an association for the user'
      status.should == 200
      response = JSON.parse(response_body, symbolize_names: true)
      response[:association][:association_type_id].should == association_type.id
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
end
