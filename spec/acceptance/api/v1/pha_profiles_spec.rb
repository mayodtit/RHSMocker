require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'PhaProfile' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:pha_lead) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:pha_profile) { create(:pha_profile, user: user) }

    get '/api/v1/pha_profiles' do
      example_request '[GET] Get all PhaProfiles' do
        explanation 'Returns an array of PhaProfiles'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:pha_profiles].to_json).to eq([pha_profile].serializer.as_json.to_json)
      end
    end

    get '/api/v1/pha_profiles/:id' do
      let(:id) { pha_profile.id }

      example_request '[GET] Get PhaProfile' do
        explanation 'Returns the PhaProfile'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:pha_profile].to_json).to eq(pha_profile.serializer.as_json.to_json)
      end
    end

    put '/api/v1/pha_profiles/:id' do
      parameter :user_id, 'User for this profile'
      parameter :bio_image, 'base64 encoded image'
      parameter :bio, 'PHA bio text'
      parameter :weekly_capacity, 'Maximum weekly PHA assignments'
      scope_parameters :pha_profile, %i(user_id bio_image bio weekly_capacity)
      required_parameters :user_id

      let(:weekly_capacity) { 1337 }
      let(:id) { pha_profile.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update PhaProfile' do
        explanation 'Update the PhaProfile'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:pha_profile][:weekly_capacity]).to eq(weekly_capacity)
      end
    end
  end

  post '/api/v1/pha_profiles' do
    parameter :user_id, 'User for this profile'
    parameter :bio_image, 'base64 encoded image'
    parameter :bio, 'PHA bio text'
    parameter :weekly_capacity, 'Maximum weekly PHA assignments'
    scope_parameters :pha_profile, %i(user_id bio_image bio weekly_capacity)
    required_parameters :user_id

    let(:user_id) { user.id }
    let(:weekly_capacity) { 1337 }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create PhaProfile' do
      explanation 'Create the PhaProfile'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:pha_profile][:weekly_capacity]).to eq(weekly_capacity)
    end
  end
end
