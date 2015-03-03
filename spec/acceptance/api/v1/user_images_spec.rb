require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'UserImage' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  before do
    CarrierWave::Mount::Mounter.any_instance.stub(:store!)
  end

  context 'existing record' do
    let!(:user_image) { create(:user_image, user: user) }

    get '/api/v1/users/:user_id/user_images' do
      example_request '[GET] Get all UserImages' do
        explanation 'Returns an array of UserImages'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_images].to_json).to eq([user_image].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/user_images/:id' do
      let(:id) { user_image.id }

      example_request '[GET] Get UserImage' do
        explanation 'Returns the UserImage'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_image].to_json).to eq(user_image.serializer.as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/user_images/:id' do
      parameter :image, 'Base64 encoded image'
      scope_parameters :user_image, %i(image)

      let(:image) { base64_test_image }
      let(:id) { user_image.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update UserImage' do
        explanation 'Update the UserImage'
        expect(status).to eq(200)
      end
    end

    delete '/api/v1/users/:user_id/user_images/:id' do
      let(:id) { user_image.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy UserImage' do
        explanation 'Destroy an UserImage'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/users/:user_id/user_images' do
    parameter :image, 'Base64 encoded image'
    parameter :client_guid, 'Client-generated unique identifier'
    scope_parameters :user_image, %i(image client_guid)

    let(:image) { base64_test_image }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create UserImage' do
      explanation 'Create the UserImage'
      expect(status).to eq(200)
    end
  end
end
