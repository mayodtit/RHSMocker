require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Associate" do
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

  get '/api/v1/users/:user_id/associates' do
    let!(:association) { create(:association, user: user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all associates for a user" do
      explanation 'Returns an array of associates for the user'
      status.should == 200
      JSON.parse(response_body)['associates'].should be_a Array
    end
  end

  get '/api/v1/users/:user_id/associates/:id' do
    let!(:association) { create(:association, user: user) }
    let(:id) { association.associate_id }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get can associate for a user" do
      explanation 'Returns an associate for the user'
      status.should == 200
      JSON.parse(response_body)['associate'].should be_a Hash
    end
  end

  post '/api/v1/users/:user_id/associates' do
    let!(:association_type) { create(:association_type) }

    parameter :first_name, "Associate's first name"
    parameter :last_name, "Associate's last name"
    parameter :birth_date, "Associate's birth date"
    parameter :phone, "Associate's phone number"
    parameter :image_url, "Associate's picture URL"
    parameter :gender, "Associate's gender (male, female)"
    parameter :height, "Associate's height (cm)"
    parameter :association_type_id, "Association type"
    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone,
                                  :image_url, :gender, :height, :association_type_id]
    required_parameters :association_type_id

    let(:first_name) { "Kyle" }
    let(:last_name) { "Chilcutt" }
    let(:birth_data) { Date.today }
    let(:phone) { '123-456-7890' }
    let(:image_url) { 'http://www.chilcutt.com/kyle.jpg' }
    let(:gender) { 'male' }
    let(:height) { 180 }
    let(:association_type_id) { association_type.id }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create an associate for a user" do
      explanation 'Create an associate for the user'
      status.should == 200
    end
  end

  put '/api/v1/users/:user_id/associates/:id' do
    let!(:association) { create(:association, user: user) }
    let!(:association_type) { create(:association_type) }
    let(:id) { association.associate_id }

    parameter :id, "Associate's ID"
    parameter :first_name, "Associate's first name"
    parameter :last_name, "Associate's last name"
    parameter :birth_date, "Associate's birth date"
    parameter :phone, "Associate's phone number"
    parameter :image_url, "Associate's picture URL"
    parameter :gender, "Associate's gender (male, female)"
    parameter :height, "Associate's height (cm)"
    parameter :association_type_id, "Association type"
    scope_parameters :associate, [:first_name, :last_name, :birth_date, :phone,
                                  :image_url, :gender, :height, :association_type_id]
    required_parameters :id

    let(:first_name) { "Kyle" }
    let(:last_name) { "Chilcutt" }
    let(:birth_data) { Date.today }
    let(:phone) { '123-456-7890' }
    let(:image_url) { 'http://www.chilcutt.com/kyle.jpg' }
    let(:gender) { 'male' }
    let(:height) { 180 }
    let(:assocation_type_id) { association_type.id }
    let(:raw_post) { params.to_json }

    example_request "[PUT] Update an associate for a user" do
      explanation 'Update an associate for the user'
      status.should == 200
    end
  end

  delete '/api/v1/users/:user_id/associates/:id' do
    let!(:association) { create(:association, user: user) }
    let(:id) { association.associate_id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Delete an associate for a user" do
      explanation 'Delete an associate for the user'
      status.should == 200
    end
  end
end
