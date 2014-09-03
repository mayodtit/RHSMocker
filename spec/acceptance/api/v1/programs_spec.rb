require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Programs" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:admin) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  context 'existing records' do
    let!(:program) { create(:program) }
    let(:id) { program.id }

    get '/api/v1/programs' do
      example_request "[GET] Get all programs" do
        explanation "Returns an array of programs"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        ids = body[:programs].map{|p| p[:id]}
        ids.should include(program.id)
      end
    end

    get '/api/v1/programs/:id' do
      example_request "[GET] Get details about a program" do
        explanation "Returns the program"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:program][:id].should == program.id
      end
    end

    put '/api/v1/programs/:id' do
      parameter :title, "Program title"
      required_parameters :title
      scope_parameters :program, [:title]

      let(:title) { "Test title" }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Update a program" do
        explanation "Returns the updated program object"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:program][:id].should == program.id
      end
    end
  end

  post '/api/v1/programs' do
    parameter :title, "Program title"
    required_parameters :title
    scope_parameters :program, [:title]

    let(:title) { "Test title" }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create a program" do
      explanation "Returns the created program object"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      Program.find(body[:program][:id]).should_not be_nil
    end
  end
end
