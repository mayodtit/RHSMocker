require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "InverseAssociations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }
  let!(:association) { create(:association, associate: user) }

  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token

  get '/api/v1/users/:user_id/inverse_associations' do
    example_request '[GET] Get all inverse_associations' do
      explanation 'Index all existing inverse_associations'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:associations].to_json).to eq([association].serializer.as_json.to_json)
    end
  end

  put '/api/v1/users/:user_id/inverse_associations/:id' do
    let(:id) { association.id }
    let(:state_event) { :disable }
    let(:raw_post) { params.to_json }

    parameter :state_event, 'State machine event'
    scope_parameters :association, [:state_event]

    example_request '[PUT] Update a inverse_association' do
      explanation 'Updates an inverse_association'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:association].to_json).to eq(association.reload.serializer.as_json.to_json)
      expect(association.reload.state?(:disabled)).to be_true
    end
  end

  delete '/api/v1/users/:user_id/inverse_associations/:id' do
    let(:id) { association.id }
    let(:raw_post) { params.to_json }

    example_request '[DELETE] Destroy an association' do
      explanation 'Destroys an association'
      expect(status).to eq(200)
      expect(Association.find_by_id(id)).to be_nil
    end
  end
end
