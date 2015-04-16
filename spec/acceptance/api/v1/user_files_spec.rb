require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'UserFile' do
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

  post '/api/v1/users/:user_id/user_files' do
    parameter :file, 'Base64 encoded file'
    scope_parameters :user_file, %i(file)

    let(:file) { base64_test_image }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create UserFile' do
      explanation 'Create the UserFile'
      expect(status).to eq(200)
    end
  end
end
