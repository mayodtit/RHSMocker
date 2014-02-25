require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Permissions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:association) { create(:association, associate: user) }
  let!(:permission) { association.permission }
  let(:id) { association.id }

  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token

  get '/api/v1/associations/:id/permission' do
    example_request '[GET] Get permission block for association' do
      explanation 'Retrieve permissions for an association'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:permission].to_json).to eq(permission.serializer.as_json.to_json)
    end
  end

  put '/api/v1/associations/:id/permission' do
    let(:basic_info) { :view }
    let(:raw_post) { params.to_json }

    parameter :basic_info, 'Permission name'
    parameter :medical_info, 'Permission level'
    parameter :care_team, 'Permission level'
    scope_parameters :permission, [:basic_level, :medical_info, :care_team]

    example_request '[PUT] Update a permission' do
      explanation 'Updates a permission'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:permission].to_json).to eq(permission.reload.serializer.as_json.to_json)
      expect(permission.basic_info).to eq(basic_info)
    end
  end
end
