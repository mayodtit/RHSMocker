require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'FeatureFlag' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:super_admin) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:feature_flag) { create(:feature_flag, mkey: 'key_1') }

    get '/api/v1/feature_flags' do
      example_request '[GET] Get all Feature Flags' do
        explanation 'Returns an array of Feature Flags'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:feature_flags].to_json).to eq([feature_flag].serializer.as_json.to_json)
      end
    end

    get '/api/v1/feature_flags/:mkey' do
      let(:mkey) { feature_flag.mkey }

      example_request '[GET] Get Feature Flag' do
        explanation 'Returns a Feature Flag'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:feature_flag].to_json).to eq(feature_flag.serializer.as_json.to_json)
      end
    end

    put '/api/v1/feature_flags/:mkey' do
      parameter :enabled, 'Boolean value of the FeatureFlag'
      scope_parameters :feature_flag, [:enabled]
      required_parameters :enabled

      let(:enabled) { true }
      let(:mkey) { feature_flag.mkey }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update FeatureFlag' do
        explanation 'Update the FeatureFlag'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:feature_flag][:enabled]).to be_true
      end
    end
  end
end
