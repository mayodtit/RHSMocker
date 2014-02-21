require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Permissions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:association) { create(:association, associate: user) }
  let(:association_id) { association.id }

  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token

  context 'existing record' do
    let!(:permission) { create(:permission, user: user, subject: association) }

    get '/api/v1/associations/:association_id/permissions' do
      example_request '[GET] Get all permissions' do
        explanation 'Index all existing permissions for an association'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:permissions].to_json).to eq([permission].as_json.to_json)
      end
    end

    put '/api/v1/associations/:association_id/permissions/:id' do
      let(:id) { permission.id }
      let(:level) { :view }
      let(:raw_post) { params.to_json }

      parameter :name, 'Permission name'
      parameter :level, 'Permission level'
      scope_parameters :permission, [:name, :level]

      example_request '[PUT] Update a permission' do
        explanation 'Updates a permission'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.reload.as_json.to_json)
        expect(permission.level).to eq(level)
      end
    end

    delete '/api/v1/associations/:association_id/permissions/:id' do
      let(:id) { permission.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy a permission' do
        explanation 'Destroys a permission'
        expect(status).to eq(200)
        expect(Permission.find_by_id(id)).to be_nil
      end
    end
  end

  post '/api/v1/associations/:association_id/permissions' do
    let(:name) { :basic_info }
    let(:level) { :view }
    let(:raw_post) { params.to_json }

    parameter :name, 'Permission name'
    parameter :level, 'Permission level'
    scope_parameters :permission, [:name, :level]

    example_request '[POST] Create a permission' do
      explanation 'Creates a permission'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      permission = Permission.find(body[:permission][:id])
      expect(body[:permission].to_json).to eq(permission.as_json.to_json)
    end
  end

  get '/api/v1/permissions/available' do
    example_request '[GET] Get available permissions settings' do
      explanation 'Retrieve information about available permissions'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body).to_not be_empty
    end
  end
end
