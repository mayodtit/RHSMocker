require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'ConsultUsers' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/consults/:id/users' do
    let(:consult) { create(:consult, users: [user, (create :user)]) }
    let(:id) { consult.id }

    example_request '[GET] Get all users associated for a given consult' do
      explanation 'Returns a list of users'
      status.should == 200

      puts response_body

      body = JSON.parse(response_body, :symbolize_names => true)[:consult_users]
      body.should be_a Array
      body.first.should be_a Hash
      body.length.should == 2
    end
  end
end